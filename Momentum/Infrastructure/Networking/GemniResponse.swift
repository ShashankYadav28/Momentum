//
//  GemniResponse.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

struct GemniResponse:Decodable {
    let candidates: [GemniCandidate]
}

struct GemniCandidate: Decodable {
    let content: GemniResponseContent
}

struct GemniResponseContent: Decodable {
    let parts: [GemniResponsePart]
}

struct GemniResponsePart: Decodable {
    let text: String
}
