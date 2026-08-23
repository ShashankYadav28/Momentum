//
//  TaskSheet.swift
//  Momentum
//
//  Created by Shashank Yadav on 23/08/26.
//

import Foundation

enum TaskSheet:Identifiable {
    
    
    case add
    case editTask(Task)
    
    var id:String {
        switch self {
        case .add:
            return "add"
        case .editTask(let task):
            return task.id.uuidString
        }
    }
}
