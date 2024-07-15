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

class FirebaseDatabase {
    
    static let shared = FirebaseDatabase()

    var databaseRef: DatabaseReference!
    var data: [ListModel?] = []
    
    var dataChanged: (() -> Void)?
    
    init() {
        Database.database().isPersistenceEnabled = true
        setupFirebase()
    }
    
    func setupFirebase() {
        databaseRef = Database.database().reference()
        
        databaseRef.child(Paths.lists.description).observe(.childAdded) { snapshot, arg in
            if let value = snapshot.value as? NSDictionary {
                self.data.append(ListModel.fromNSDictionary(value))
                self.dataChanged?()
            }
        } 
        
        databaseRef.child(Paths.lists.description).observe(.childChanged) { snapshot, arg in
            if let value = snapshot.value as? NSDictionary {
                let item = ListModel.fromNSDictionary(value)
                self.updated(with: item)
                self.dataChanged?()
            }
        }

        databaseRef.child(Paths.lists.description).observe(.childRemoved) { snapshot,arg  in
            if let value = snapshot.value as? NSDictionary {
                let item = ListModel.fromNSDictionary(value)
                self.remove(item: item)
                self.dataChanged?()
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
    
}

// MARK: - Typealias
extension FirebaseDatabase {
    
    typealias Paths = FirebaseDatabasePaths
    
}
