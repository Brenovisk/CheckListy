//
//  DeleteListUseCase.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/03/26.
//

class DeleteListUseCase {
    private let repository: ListsRepositoryProtocol
    
    init(repository: ListsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(list: ListModel, userId: String) async throws {
        let isOwner = list.owner == userId
        
        if !isOwner {
            deleteUserShared(with: userId, from: list)
            return
        }
        
        try await repository.delete(list: list)
    }
    
}

extension DeleteListUseCase {
    
    private func deleteUserShared(with id: String, from list: ListModel) {
        var usersShared = list.usersShared
        usersShared.removeAll { $0 == id }
        repository.updateUsersShared(of: list.id.uuidString, with: usersShared)
    }
    
}
