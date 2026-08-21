//
//  Task.swift
//  Momentum
//
//  Created by Shashank Yadav on 12/07/26.
//

import Foundation

struct Task: Identifiable{
    
    init(
        title:String,
        description: String? = nil,
        dueDate: Date? = nil,
        link: URL? = nil,
        sourceMessageID: UUID? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.dueDate = dueDate
        self.updatedAt = nil
        self.description = description
        self.link = link
        self.sourceMessageID = sourceMessageID
        self.isCompleted = false
    }
    
    init(
        
        id:UUID,
        title:String,
        description: String?,
        createdAt: Date,
        updatedAt: Date?,
        dueDate: Date?,
        link: URL?,
        isCompleted: Bool,
        sourceMessageID: UUID?,
        
    
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.updatedAt = updatedAt
        self.description = description
        self.link = link
        self.sourceMessageID = sourceMessageID
        self.isCompleted = isCompleted
    }
    
    let id: UUID
    let sourceMessageID: UUID?
    var title: String
    var description: String?
    let createdAt: Date
    var updatedAt: Date?
    var dueDate: Date?
    var link:URL?
    var isCompleted: Bool
    
    
}
