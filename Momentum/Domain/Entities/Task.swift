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
