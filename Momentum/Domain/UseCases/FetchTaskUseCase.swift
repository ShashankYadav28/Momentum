//
//  FetchTaskUseCase.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/07/26.
//
 import Foundation

final class FetchTaskUseCase {
    
    private let repository:TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func fetch() throws-> [Task] {
        let tasks:[Task]
        do {
            return try repository.fetchTask()
        } catch {
            print(error.localizedDescription)
            throw error
        }
        
        
    }
    
    
}
