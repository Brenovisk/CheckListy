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
    
    func execute(list: ListModel) async throws {
        try await repository.delete(list: list)
    }
}
