//
//  P.swift
//  Momentum
//
//  Created by Shashank Yadav on 14/08/26.
//


import Foundation
extension AppDIContainer {
    
    static var preview: AppDIContainer {
        do {
            return try AppDIContainer()
        } catch {
            fatalError("Preview  DI Container failed \(error)")
        }
    }
}
