//
//  Config.swift
//  Momentum
//
//  Created by Shashank Yadav on 28/08/26.
//

import Foundation

enum Config {
    static var geminiAPIKey:String {
        guard let key  = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String else {
            fatalError("Key Not Found")
        }
        
        return key
    }
}
