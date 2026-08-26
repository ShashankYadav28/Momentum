//
//  TaskParsingService.swift
//  Momentum
//
//  Created by Shashank Yadav on 24/08/26.
//

import Foundation

protocol TaskParsingService {
    
    func parse(message:String) async throws -> [Task]
    
}
