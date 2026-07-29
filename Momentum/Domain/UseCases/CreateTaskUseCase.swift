//
//  CreateTaskUseCase.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/07/26.
//

import Foundation

final class CreateTaskUseCase {
    
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func execute(task: Task) throws {
        do  {
            try repository.save(task)
        }catch {
            print(error.localizedDescription)
           
            throw error
        }
        
    }
    
}

