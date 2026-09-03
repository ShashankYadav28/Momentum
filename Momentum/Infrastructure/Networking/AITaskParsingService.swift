//
//  AITaskParsingService.swift
//  Momentum
//
//  Created by Shashank Yadav on 26/08/26.
//

import Foundation

final class AITaskParsingService: TaskParsingService {
   
    private let apiClient:APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func parse(message: String) async throws -> [Task] {
        
        
        print("🔥 AITaskParsingService.parse() CALLED")
        guard let url  = URL(string: "https://generativelanguage.googleapis.com/v1beta/interactions") else {
            throw APIError.invalidURL
        }
        
//        let gemnirequest = GemniRequest(content: [
//            GemniContent(parts: [
//                GemniPart(text: message)
//            ])
//        ])
//
                
// local Json testing
//        let mockJSON = """
//        {
//            "steps": [
//                {
//                    "type": "message",
//                    "content": [
//                        {
//                            "type": "text",
//                            "text": "Test task response"
//                        }
//                    ]
//                }
//            ]
//        }
//        """
//        let mockData = Data(mockJSON.utf8)
//        let decodedData = try JSONDecoder().decode(GemniResponse.self, from: mockData)
//        let text = decodedData.steps[0].content[0].text
//        print(decodedData)

        
        let gemniRequest = GemniRequest(model: "gemini-3.7-flash", input: message);
        let body = try JSONEncoder().encode(gemniRequest) ;
        
        let apiRequest = APIRequest(url: url, method: .post,  headers:  [ "Content-Type": "application/json",
                                    "x-goog-api-key": Config.geminiAPIKey
                                                                        ], body: body);
        
        
        let data = try await apiClient.send(apiRequest)
        print(String(data: data, encoding: .utf8))
        let decodedData = try JSONDecoder().decode(GemniResponse.self, from: data)
        print(decodedData)
        
//        let parsedTask =

        return []
    }
    
}


