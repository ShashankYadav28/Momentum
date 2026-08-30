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
    
}

//struct GemniContent: Codable {
//    let parts:[GemniPart]
//}
//
//
//struct GemniPart:Codable {
//    let text:String
//}
