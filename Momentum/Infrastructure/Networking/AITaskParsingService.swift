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

        let properties: [String: JSONProperty] = [
            "title": JSONProperty(
                type: ["string"],
                description: "A short, concise name describing the main action of the task.",
                format: nil
            ),

            "description": JSONProperty(
                type: ["string", "null"],
                description: "Concise additional context relevant to completing the task. Do not repeat the title, due date, or link.",
                format: nil
            ),

            "dueDate": JSONProperty(
                type: ["string", "null"],
                description: "The deadline by which the task must be completed. If only a date is provided without a time, use the end of that calendar day. Return null if there is no clear deadline.",
                format: "date-time"
            ),

            "link": JSONProperty(
                type: ["string", "null"],
                description: "The relevant URL associated with the task. Return null if no URL is provided.",
                format: nil
            )
        ]

        let schema = JSONSchema(type: "object", properties: properties, required: ["title","description","dueDate","link"])

        let responseFormat = ResponseFormat(type: "text", mimeType: "application/json", schema: schema)
        let gemniRequest = GemniRequest(model: "gemini-3.7-flash", input: message, responseFormat: responseFormat);
        let body = try JSONEncoder().encode(gemniRequest) ;

        let apiRequest = APIRequest(url: url, method: .post,  headers:  [ "Content-Type": "application/json",
                                    "x-goog-api-key": Config.geminiAPIKey
                                                                        ], body: body);


        let data = try await apiClient.send(apiRequest)
        print(String(data: data, encoding: .utf8))
        let decodedData = try JSONDecoder().decode(GemniResponse.self, from: data)
        let modelOutputStep = decodedData.steps.first {
            $0.type == "model_output"
        }

        guard let modelOutputStep else {
            throw APIError.invalidResponse
        }

        guard let content = modelOutputStep.content else {
            throw APIError.invalidResponse
        }

        guard let textContent = content.first(where: {
            $0.type == "text"
        }) else {
            throw APIError.invalidResponse
        }

        guard let jsonString = textContent.text else {
            throw APIError.invalidResponse
        }

        guard let jsonData = jsonString.data(using: .utf8) else {
            throw APIError.invalidResponse
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let parsedTask = try decoder.decode(ParsedTask.self, from: jsonData)
        let task  = TaskMapper.toDomain(parsedTask: parsedTask)
        print(decodedData)

//        let parsedTask =
        return [task] ;
        
    }
}


