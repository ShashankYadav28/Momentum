//
//  AITaskParsingService.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

import Foundation

final class ATtaskParsingService: TaskParsingService {
   
    private let apiClient:APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    let apiRequest = APIRequest(url: , method: .post, headers: , body: )
    
    func parse(message: String) async throws -> [Task] {
        let gemnirequest = GemniRequest(content: [
            GemniContent(parts: [
                GemniPart(text: message)
            ])
        ])
        
        let body = try JSONEncoder().encode(gemnirequest)

    }
}


