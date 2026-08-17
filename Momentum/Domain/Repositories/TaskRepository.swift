//
//  TaskkReposi.swift
//  Momentum
//
//  Created by Shashank Yadav on 13/07/26.
//

import Foundation

protocol TaskRepository {
    
    func save(_ task:Task) throws
    
    func fetchTask() throws -> [Task]
    
    func delete(_ task:Task) throws
    
    func update(_ task:Task) throws
    
}
