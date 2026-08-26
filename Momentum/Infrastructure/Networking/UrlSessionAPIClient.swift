//
//  UrlSessionAPIClient.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

import Foundation

final class UrlSessionAPIClient:APIClient {
    func send(_ request: APIRequest) async throws -> Data {
        var urlRequest = URLRequest(url: request.url) // own api request is converted in apple request
        
        urlRequest.httpMethod = request.method.rawValue
        
        for (key,value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        urlRequest.httpBody = request.body
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return data 
        
    }
    
    
//    func send
}
 
