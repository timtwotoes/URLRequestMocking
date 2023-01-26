import XCTest
@testable import URLRequestMocking

final class URLRequestMockingTests: XCTestCase {
    func testURLRequestMock() async throws {
        let session = URLSession(configuration: .mock(for: .ephemeral))
        var mockedRequest = URLRequest(url: URL(string: "https://example.com")!)
        var unknownRequest = URLRequest(url: URL(string: "https://examples.com")!)
        let mock = URLRequestMock { request in
            if request.url?.absoluteString == "https://example.com" {
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, "Success!".data(using: .utf8)!)
            } else {
                let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
                return (response, "Not found!".data(using: .utf8)!)
            }
        }
        
        mockedRequest.mock = mock
        unknownRequest.mock = mock
        
        let (successData, successResponse) = try await session.data(for: mockedRequest)
        XCTAssertTrue((successResponse as! HTTPURLResponse).statusCode == 200)
        XCTAssertEqual(String(data: successData, encoding: .utf8), "Success!")
        
        let (invalidData, invalidResponse) = try await session.data(for: unknownRequest)
        XCTAssertTrue((invalidResponse as! HTTPURLResponse).statusCode == 401)
        XCTAssertEqual(String(data: invalidData, encoding: .utf8), "Not found!")
    }
    
    func testURLSessionConfigurationMock() async throws {
        let mock = URLRequestMock { request in
            if request.url?.absoluteString == "https://apple.com" {
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, "Success".data(using: .utf8)!)
            } else {
                let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
                return (response, "Failure".data(using: .utf8)!)
            }
        }
        let session = URLSession(configuration: .mock(for: .ephemeral, using: mock))
        
        let (successData, successResponse) = try await session.data(for: URLRequest(url: URL(string: "https://apple.com")!))
        XCTAssertTrue((successResponse as! HTTPURLResponse).statusCode == 200)
        XCTAssertEqual(String(data: successData, encoding: .utf8), "Success")
        
        let (failureData, failureResponse) = try await session.data(for: URLRequest(url: URL(string: "https://microsoft.com")!))
        XCTAssertTrue((failureResponse as! HTTPURLResponse).statusCode == 404)
        XCTAssertEqual(String(data: failureData, encoding: .utf8), "Failure")
    }
}
