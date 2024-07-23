//
//  ListsViewModel.swift
//  CheckListy
//
//  Created by Breno Lucas on 02/07/24.
//

import Foundation
import SwiftUI
import Combine

class ListsViewModel: ObservableObject {
    
    @Published var lists: [ListModel?] = []
    @Published var listToEdit: ListModel? = nil
    @Published var selectedList: ListModel? = nil
    @Published var visualizationMode: ListMode = .list
    
    private let firebaseDataBase = FirebaseDatabase.shared
    
    init() {
        setupCallbacksManager()
        self.lists = firebaseDataBase.data
    }
    
    func create(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDataBase.add(path: pathNewList, data: list.toNSDictionary())
    }
    
    func delete(list: ListModel) {
        let pathNewList = "\(Paths.lists.description)/\(list.id.uuidString)"
        firebaseDataBase.delete(path: pathNewList)
    }
    
    func signOut() {
        Task {
            do {
                try await FirebaseAuthService.shared.signOut()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func toggleVisualization() {
        withAnimation {
            visualizationMode = visualizationMode == .list ? .grid : .list
        }
    }
    
}

// MARK: - Helper methods
extension ListsViewModel {
    
    private func setupCallbacksManager() {
        firebaseDataBase.dataChanged = { [weak self] in
            self?.lists = self?.firebaseDataBase.data ?? []        }
    }
    
}

// MARK: - Typealias
extension ListsViewModel {
    
    typealias Paths = FirebaseDatabasePaths
    
}
