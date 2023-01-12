import XCTest
@testable import URLRequestMocking

final class URLRequestMockingTests: XCTestCase {
    func testMock() async throws {
        let session = URLSession(configuration: .mock(for: .ephemeral))
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.mock = URLRequestMock { request in
            URLResponse(url: URL(string: "https://example.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
            Data()
        }
        
        let result = try await session.data(for: request)
    }
}
