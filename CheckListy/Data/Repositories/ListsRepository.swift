//
//  ListsRepository.swift
//  CheckListy
//

import Foundation
import Combine
import FirebaseDatabase

class ListsRepository: ListsRepositoryProtocol {
    
    private let firebaseDatabase: FirebaseDatabase
    
    init(firebaseDatabase: FirebaseDatabase) {
        self.firebaseDatabase = firebaseDatabase
    }
    
    func observeLists(userId: String) -> AnyPublisher<[ListModel], Never> {
        firebaseDatabase.observeUserLists(userId: userId)
        return firebaseDatabase.dataChanged
            .map { listModels in
                listModels.compactMap { $0 }
            }
            .eraseToAnyPublisher()
    }
    
    func save(list: ListModel) async throws {
        let path = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.add(path: path, data: ListDTO.fromDomain(list))
    }
    
    func update(list: ListModel) async throws {
        let path = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.update(path: path, data: ListDTO.fromDomain(list))
    }
    
    func delete(list: ListModel) async throws {
        let path = "\(FirebaseDatabasePaths.lists.description)/\(list.id.uuidString)"
        firebaseDatabase.delete(path: path)
    }
    
    func getList(id: String) async throws -> ListModel {
        let data: NSDictionary = try await firebaseDatabase.getRawData(from: .lists, with: id)
        guard let list = ListDTO.toDomain(data) else {
            throw NSError(domain: "MappingError", code: -1)
        }
        return list
    }
    
    func updateUsersShared(of listId: String, with usersId: [String]) {
        let path = "\(FirebaseDatabasePaths.lists.description)/\(listId)/usersShared"
        firebaseDatabase.update(path: path, data: usersId.toNSDictionary())
    }
    
}
