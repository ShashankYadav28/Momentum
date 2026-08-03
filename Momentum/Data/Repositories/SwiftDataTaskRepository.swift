//
//  SwiftDataTaskRepository.swift
//  Momentum
//
//  Created by Shashank Yadav on 15/07/26.
//

import Foundation
import SwiftData

final class SwiftDataTaskRepository:TaskRepository {
    
    private let modelContext:ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    
    func save(_ task: Task) throws {
        
        let taskModel = TaskMapper.toPersistence(task: task)
        modelContext.insert(taskModel)
        do {
            try modelContext.save()
        }
        catch  {
            print(error.localizedDescription)
            throw error
        }
        
    }
    
    func fetchTask() throws -> [Task] {
        
        let models:[SwiftDataTaskModel]
        let descriptor = FetchDescriptor<SwiftDataTaskModel>()
        do {
            models = try modelContext.fetch(descriptor)
            
            return models.map {
                TaskMapper.toDomain(model: $0)
            }
        }catch {
            print(error.localizedDescription)
            throw error
        }
//        let tasks = models.map { model in
//            TaskMapper.toDomain(model: model)
//        }
//        
//        return tasks
//
        
    }
    
    func delete(_ task: Task) throws {
        
        let descriptor = FetchDescriptor<SwiftDataTaskModel>(
            predicate: #Predicate<SwiftDataTaskModel> { model in
                model.id == task.id
            }
        )
        do {
            let models  = try modelContext.fetch(descriptor)
            guard let model = models.first
            else {
                throw RepositryError.taskNotFound
            }
            modelContext.delete(model)
            try modelContext.save()
        }catch {
            print(error.localizedDescription)
            throw RepositryError.taskNotFound
        }

    }
    
    func update(_ task: Task) throws {
        let descriptor = FetchDescriptor<SwiftDataTaskModel>(
            predicate: #Predicate { model in
                model.id == task.id
            }
        )
        do {
            let models = try modelContext.fetch(descriptor)
            guard let model = models.first else {
                throw RepositryError.taskNotFound
                
            }
            TaskMapper.updatePersistence(model: model, task: task)
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    
   
}
