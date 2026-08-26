//
//  APIError.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

import Foundation

enum APIError:Error {
    
    case invalidResponse
    case httpError(statusCode:Int)
}
