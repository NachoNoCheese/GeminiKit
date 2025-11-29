import XCTest
@testable import GeminiKit

final class ResponseTests: XCTestCase {
    func testDecodePromptFeedbackOnly() throws {
        let json = """
        {
            "promptFeedback": {
                "blockReason": "SAFETY",
                "safetyRatings": [
                    {
                        "category": "HARM_CATEGORY_HATE_SPEECH",
                        "probability": "HIGH"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(GenerateContentResponse.self, from: json)
        
        XCTAssertNil(response.candidates)
        XCTAssertNotNil(response.promptFeedback)
        XCTAssertEqual(response.promptFeedback?.blockReason, BlockReason.safety)
        XCTAssertEqual(response.promptFeedback?.safetyRatings?.first?.category, HarmCategory.hateSpeech)
        XCTAssertEqual(response.promptFeedback?.safetyRatings?.first?.probability, HarmProbability.high)
    }
    
    func testDecodeCandidatesAndFeedback() throws {
        let json = """
        {
            "candidates": [
                {
                    "content": {
                        "role": "model",
                        "parts": [{"text": "Hello"}]
                    },
                    "finishReason": "STOP"
                }
            ],
            "promptFeedback": {
                "safetyRatings": []
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(GenerateContentResponse.self, from: json)
        
        XCTAssertNotNil(response.candidates)
        XCTAssertEqual(response.candidates?.count, 1)
        XCTAssertNotNil(response.promptFeedback)
    }
}
