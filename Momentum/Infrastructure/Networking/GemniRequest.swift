//
//  GemniRequest.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

import Foundation

struct GemniRequest:Encodable {
//    let content:[GemniContent]
    let model: String
    let input: String
    let responseFormat:ResponseFormat
    
}

struct ResponseFormat:Encodable  {
    let type:String
    let mimeType:String
    let schema:JSONSchema
}

struct JSONSchema: Encodable {
    let type: String
    let properties: [String:JSONProperty]
    let required: [String]
}

struct JSONProperty: Encodable {
    
    let type: String
    let description: String
    let format: String?
    
}

//struct GemniContent: Codable {
//    let parts:[GemniPart]
//}
//
//
//struct GemniPart:Codable {
//    let text:String
//}
