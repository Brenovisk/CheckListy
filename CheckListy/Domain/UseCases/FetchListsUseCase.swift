//
//  FetchListsUseCase.swift
//  CheckListy
//

import Foundation
import Combine

class FetchListsUseCase {
    private let repository: ListsRepositoryProtocol
    
    init(repository: ListsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String) -> AnyPublisher<[ListModel], Never> {
        return repository.observeLists(userId: userId)
    }
}
