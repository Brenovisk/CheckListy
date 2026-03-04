//
//  AddSharedList.swift
//  CheckListy
//
//  Created by Breno Lucas on 04/03/26.
//

import Foundation

class AddSharedList {
    
    private let listRepository: ListsRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(listRepository: ListsRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.listRepository = listRepository
        self.userRepository = userRepository
    }
    
    func execute(currentLists: [String], userId: String, sharedCode: String) async throws {
        guard let listId = getListId(from: sharedCode) else {
            throw NSError(domain: "AddSharedList", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid shared code"])
        }
        
        addListInUser(ids: currentLists, listId, userId)
        try await addUserInList(listId, userId)
    }
    
}

extension AddSharedList {
        
    private func getListId(from sharedCode: String) -> String? {
        guard let listId = sharedCode.removingSuffix(".co").fromBase64Code() else {
            return nil
        }
        
        return listId
    }
    
    private func addListInUser(ids: [String], _ listId: String, _ userId: String) {
        var currentLists = ids
        currentLists.append(listId)
        userRepository.updateLists(ids: currentLists, userId: userId)
    }
    
    private func addUserInList(_ listId: String, _ userId: String) async throws {
        var usersShared = try await listRepository.getList(id: listId).usersShared
        usersShared.append(userId)
        listRepository.updateUsersShared(of: listId, with: usersShared)
    }
}
