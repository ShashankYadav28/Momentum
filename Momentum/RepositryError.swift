//
//  RespositryError.swift
//  Momentum
//
//  Created by Shashank Yadav on 31/07/26.
//

import Foundation

enum RepositryError:Error {
    
    case taskNotFound
    case saveFailed
    case fetchFailed
    case deleteFailed
    
}
