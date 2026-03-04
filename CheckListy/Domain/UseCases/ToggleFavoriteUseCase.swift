//
//  ToggleFavoriteUseCase.swift
//  CheckListy
//

import Foundation

class ToggleFavoriteUseCase {
    private let repository: ListsRepositoryProtocol
    
    init(repository: ListsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(list: ListModel) async throws {
        var updatedList = list
        updatedList.isFavorite.toggle()
        try await repository.update(list: updatedList)
    }
}
