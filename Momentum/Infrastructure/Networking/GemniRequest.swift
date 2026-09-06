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

    enum CodingKeys: String, CodingKey {
        case model
        case input
        case responseFormat = "response_format"
    }

}

struct ResponseFormat:Encodable  {
    let type:String
    let mimeType:String
    let schema:JSONSchema

    enum CodingKeys: String, CodingKey {
        case type
        case mimeType = "mime_type"
        case schema
    }
}

struct JSONSchema: Encodable {
    let type: String
    let properties: [String:JSONProperty]
    let required: [String]
}

struct JSONProperty: Encodable {

    let type: [String]
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
