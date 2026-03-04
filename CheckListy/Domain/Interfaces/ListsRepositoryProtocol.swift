//
//  ListsRepositoryProtocol.swift
//  CheckListy
//
//  Created by Breno Lucas on 11/02/26.
//

import Foundation
import Combine

protocol ListsRepositoryProtocol {
    func observeLists(userId: String) -> AnyPublisher<[ListModel], Never>
    func save(list: ListModel) async throws
    func update(list: ListModel) async throws
    func delete(list: ListModel) async throws
    func getList(id: String) async throws -> ListModel
    func updateUsersShared(of listId: String, with usersId: [String])
}

