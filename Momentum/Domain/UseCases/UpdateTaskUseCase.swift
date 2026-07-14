//
//  UpdateTaskUseCase.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/07/26.
//

import Foundation

final class UpdateTaskUseCase {
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func update(task:Task) {
        repository.update(task)
    }
}
