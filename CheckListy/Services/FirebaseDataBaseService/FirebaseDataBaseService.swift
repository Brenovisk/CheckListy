//
//  FirebaseDataBaseService.swift
//  CheckListy
//
//  Created by Breno Lucas on 09/07/24.
//

import Combine
import Firebase
import FirebaseDatabase
import Foundation
import SwiftUI

class FirebaseDatabase {

    static let shared = FirebaseDatabase()

    var databaseRef: DatabaseReference!

    var data: [ListModel?] = [] {
        didSet {
            dataChanged.send(data)
        }
    }

    var dataChanged = PassthroughSubject<[ListModel?], Never>()

    private var listObservers: [String: DatabaseHandle] = [:]

    private var childAddedHandle: DatabaseHandle?
    private var childChangedHandle: DatabaseHandle?
    private var childRemovedHandle: DatabaseHandle?

    init() {
        Database.database().isPersistenceEnabled = true
        databaseRef = Database.database().reference()
    }

    func observeUserLists(userId: String) {
        // Observe user data to get list IDs
        let userRef = databaseRef.child(Paths.users.description).child(userId)

        userRef.observe(.value) { [weak self] snapshot, _ in
            guard let self = self else { return }
            guard let value = snapshot.value as? NSDictionary else { return }
            let listIds = value["lists"] as? [String] ?? []
            self.observeLists(listIds: listIds)
        }
    }

    func add(path: String, data: NSDictionary) {
        databaseRef.child(path).setValue(data)
    }

    func add(path: String, data: String) {
        databaseRef.child(path).setValue(data)
    }

    func delete(path: String) {
        databaseRef.child(path).setValue(nil)
    }

    func update(path: String, data: NSDictionary) {
        let childUpdates = ["\(path)": data]
        databaseRef.updateChildValues(childUpdates)
    }

    func getData<T: ConvertibleDictionary>(from path: Paths, with childId: String) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.databaseRef.child(path.description).child(childId).observeSingleEvent(of: .value) { snapshot, _ in
                guard let value = snapshot.value as? NSDictionary else {
                    continuation.resume(throwing: DataError.fetchError)
                    return
                }

                if let data = T.fromNSDictionary(value) {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: DataError.parseError)
                }
            }
        }
    }

    func clearData() {
        removeListObservers()
        data = []
    }

    @MainActor
    func deleteFromDataLocal(_ list: ListModel) throws {
        guard let index = data.firstIndex(where: { $0?.id == list.id }) else {
            throw NSError(domain: String(), code: 0)
        }

        var dataToUpdate = data
        dataToUpdate.remove(at: index)

        data = dataToUpdate
    }

}

// MARK: - Helper methods
extension FirebaseDatabase {

    private func updated(with newItem: ListModel?) {
        if let index = data.firstIndex(where: { $0?.id == newItem?.id }) {
            data[index] = newItem
        }
    }

    private func remove(item: ListModel?) {
        if let index = data.firstIndex(where: { $0?.id == item?.id }) {
            data.remove(at: index)
        }
    }

    private func observeLists(listIds: [String]) {
        // Remove previous observers to avoid duplicate listening
        removeListObservers()
        data = [] // Clear existing data

        for listId in listIds {
            addObserverList(with: listId)
        }
    }

    func addObserverList(with listId: String) {
        let listRef = databaseRef.child(Paths.lists.description).child(listId)

        // Observe each list
        let addedHandle = listRef.observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            guard let value = snapshot.value as? NSDictionary else { return }

            let listItem = ListModel.fromNSDictionary(value)
            self.updateList(with: listItem)
        }

        listObservers[listId] = addedHandle
    }

    @MainActor
    func removeObserverList(with listId: String) throws {
        guard let handle = listObservers[listId] else {
            throw FirebaseError.observerNotFound(listId: listId)
        }

        let listRef = databaseRef.child(Paths.lists.description).child(listId)
        listRef.removeObserver(withHandle: handle)
        listObservers.removeValue(forKey: listId)
    }

    private func updateList(with newItem: ListModel?) {
        guard let newItem = newItem else { return }

        if let index = data.firstIndex(where: { $0?.id == newItem.id }) {
            data[index] = newItem
            return
        }

        data.append(newItem)
    }

    private func removeListObservers() {
        for (listId, handle) in listObservers {
            databaseRef.child(Paths.lists.description).child(listId).removeObserver(withHandle: handle)
        }
        listObservers.removeAll()
    }

}

// MARK: - Typealias
extension FirebaseDatabase {

    typealias Paths = FirebaseDatabasePaths

}

enum DataError: Error {

    case fetchError
    case parseError
    case invalidPath

}

enum FirebaseError: Error {

    case observerNotFound(listId: String)

}
