//
//  FirebaseRealtime.swift
//  CheckListy
//
//  Created by Breno Lucas on 09/07/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import Combine

class FirebaseDatabase {
    
    static let shared = FirebaseDatabase()
    
    var databaseRef: DatabaseReference!
    
    var data: [ListModel?] = [] {
        didSet {
            dataChanged.send(data)
        }
    }
    
    var dataChanged = PassthroughSubject<[ListModel?], Never>()
    
    private var childAddedHandle: DatabaseHandle?
    private var childChangedHandle: DatabaseHandle?
    private var childRemovedHandle: DatabaseHandle?
    
    init() {
        Database.database().isPersistenceEnabled = true
        setupIfNeeded()
    }
    
    func setupIfNeeded() {
        guard childAddedHandle == nil,
              childChangedHandle == nil,
              childRemovedHandle == nil else {
            return
        }
        
        setupFirebase()
    }
    
    func setupFirebase() {
        databaseRef = Database.database().reference()
        
        childAddedHandle = databaseRef.child(Paths.lists.description).observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            if let value = snapshot.value as? NSDictionary {
                self.data.append(ListModel.fromNSDictionary(value))
            }
        }
        
        childChangedHandle = databaseRef.child(Paths.lists.description).observe(.childChanged) { [weak self] snapshot in
            guard let self = self else { return }
            if let value = snapshot.value as? NSDictionary {
                let item = ListModel.fromNSDictionary(value)
                self.updated(with: item)
            }
        }
        
        childRemovedHandle = databaseRef.child(Paths.lists.description).observe(.childRemoved) { [weak self] snapshot in
            guard let self = self else { return }
            if let value = snapshot.value as? NSDictionary {
                let item = ListModel.fromNSDictionary(value)
                self.remove(item: item)
            }
        }
    }
    
    func add(path: String, data: NSDictionary) {
        self.databaseRef.child(path).setValue(data)
    }
    
    func delete(path: String) {
        self.databaseRef.child(path).setValue(nil)
    }
    
    func update(path: String, data: NSDictionary) {
        let childUpdates = ["\(path)": data]
        self.databaseRef.updateChildValues(childUpdates)
    }
    
}

// MARK: - Helper methods
extension FirebaseDatabase {
    
    private func updated(with newItem: ListModel?) {
        if let index = data.firstIndex(where: {$0?.id == newItem?.id}) {
            self.data[index] = newItem
        }
    }
    
    private func remove(item: ListModel?) {
        if let index = data.firstIndex(where: {$0?.id == item?.id}) {
            self.data.remove(at: index)
        }
    }
    
    func removeListeners() {
        if let handle = childAddedHandle {
            databaseRef.child(Paths.lists.description).removeObserver(withHandle: handle)
            childAddedHandle = nil
        }
        
        if let handle = childChangedHandle {
            databaseRef.child(Paths.lists.description).removeObserver(withHandle: handle)
            childChangedHandle = nil
        }
        
        if let handle = childRemovedHandle {
            databaseRef.child(Paths.lists.description).removeObserver(withHandle: handle)
            childRemovedHandle = nil
        }
    }
    
    func clearData() {
        data = []
    }
    
}

// MARK: - Typealias
extension FirebaseDatabase {
    
    typealias Paths = FirebaseDatabasePaths
    
}
