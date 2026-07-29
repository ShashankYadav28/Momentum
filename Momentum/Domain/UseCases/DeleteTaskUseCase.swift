//
//  DeleteTaskUseCase.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/07/26.
//

import Foundation

final class DeleteTaskUseCase {
    
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func delete(task:Task) throws {
        do {
            try repository.delete(task)
        } catch {
            throw error
        }
        
    }
}
