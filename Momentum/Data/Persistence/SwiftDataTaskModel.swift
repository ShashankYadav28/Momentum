//
//  SwiftDataTaskModel.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/07/26.
//

import Foundation
import SwiftData

@Model
final class SwiftDataTaskModel {
    
    var id:UUID
    var createdAt:Date
    var dueDate:Date?
    var title:String
    var taskDescription:String?
    var link: URL?
    var isCompleted: Bool
    var sourceMessageID: UUID?
    var updatedAt:Date?
    
    init(
        id: UUID,
        createdAt: Date,
        dueDate: Date?,
        title: String,
        description: String?,
        link: URL?,
        isCompleted: Bool,
        sourceMessageID: UUID?,
        updatedAt: Date?
    )
    {
        self.id = id
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.title = title
        self.taskDescription = description
        self.link = link
        self.isCompleted = isCompleted
        self.sourceMessageID = sourceMessageID
        self.updatedAt = updatedAt
    }
    
}
