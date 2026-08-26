//
//  APIClient.swift
//  Momentum
//
//  Created by Shashank Yadav on 25/08/26.
//

import Foundation

enum HTTPMethod:String{
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}

struct APIRequest {
    
    let url: URL
    let method: HTTPMethod
    let headers: [ String:String]
    let body: Data?
}

protocol APIClient {
    
    func send(_ request:APIRequest) async throws -> Data
}
