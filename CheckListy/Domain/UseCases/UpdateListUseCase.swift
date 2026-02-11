//
//  UpdateListUseCase.swift
//  CheckListy
//

import Foundation

class UpdateListUseCase {
    private let repository: ListsRepositoryProtocol
    
    init(repository: ListsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(list: ListModel) async throws {
        try await repository.update(list: list)
    }
}
