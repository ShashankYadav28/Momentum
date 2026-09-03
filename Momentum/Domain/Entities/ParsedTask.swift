//
//  ParsedTask.swift
//  Momentum
//
//  Created by Shashank Yadav on 30/08/26.
//

import Foundation

struct ParsedTask:Codable {
    
    let title: String
    let description: String?
    let dueDate: Date?
    let iink: URL?
}
