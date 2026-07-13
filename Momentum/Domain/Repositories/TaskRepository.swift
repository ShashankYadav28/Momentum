//
//  TaskkReposi.swift
//  Momentum
//
//  Created by Shashank Yadav on 13/07/26.
//

import Foundation

protocol TaskRepository {
    
    func save(_ task:Task)
    
    func fetchTask()->[Task]
    
    func delete(_ task:Task)
    
    func update(_ task:Task)
}
