//
//  SourceMessage.swift
//  Momentum
//
//  Created by Shashank Yadav on 13/07/26.
//

import Foundation

struct SourceMessage: Identifiable {
    
    let id = UUID()
    var content:String
    let createdAt = Date()
    
}
