//
//  GemniResponse.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

struct GemniResponse:Decodable {
    let steps: [GemniStep]
}

struct GemniStep: Decodable {
    let type: String
    let content: [GemniResponseContent]
}

struct GemniResponseContent: Decodable {
    let type: String
    let text: String?
}


