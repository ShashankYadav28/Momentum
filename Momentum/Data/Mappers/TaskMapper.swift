//
//  TaskMapper.swift
//  Momentum
//
//  Created by Shashank Yadav on 15/07/26.
//

import Foundation

enum TaskMapper {
     static func toPersistence(task:Task) -> SwiftDataTaskModel {
        
        return SwiftDataTaskModel(id: task.id, createdAt: task.createdAt, dueDate: task.dueDate, title: task.title, description: task.description, link: task.link, isCompleted: task.isCompleted, sourceMessageID: task.sourceMessageID, updatedAt: task.updatedAt)
    }
    
     static func toDomain(model:SwiftDataTaskModel) -> Task {
        return Task(id: model.id, title: model.title, description: model.taskDescription, createdAt: model.createdAt, updatedAt: model.updatedAt, dueDate: model.dueDate, link: model.link, isCompleted: model.isCompleted, sourceMessageID: model.sourceMessageID)
    }
    
}
