import XCTest
@testable import URLRequestMocking

final class URLRequestMockingTests: XCTestCase {
    private var session: URLSession!
    private var cocktailDetailsResponseURL: URL!
    private var searchByCocktailNameResponseURL: URL!
    
    override func setUpWithError() throws {
        cocktailDetailsResponseURL = try XCTUnwrap(Bundle.module.url(forResource: "Resources/lookup-full-cocktail-details-response", withExtension: "json"))
        searchByCocktailNameResponseURL = try XCTUnwrap(Bundle.module.url(forResource: "Resources/search-cocktail-by-name-response", withExtension: "json"))
        
        session = URLSession(configuration: .mock(for: .ephemeral, using: URLRequestMock { request in
            switch request.url!.absoluteString {
            case "www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11001":
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type" : "application/json"])!
                return (response, try Data(contentsOf: self.cocktailDetailsResponseURL))
            default: return nil
            }
        }))
    }
    
    override func tearDownWithError() throws {
        session = nil
        cocktailDetailsResponseURL = nil
        searchByCocktailNameResponseURL = nil
    }
    
    func testURLSessionMock() async throws {
        let (data, response) = try await session.data(for: URLRequest(url: URL(string: "www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11001")!))
        XCTAssertTrue((response as! HTTPURLResponse).statusCode == 200)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String : Any])
        let details = try XCTUnwrap(try XCTUnwrap(json["drinks"] as? [[String: String?]]).first)
        XCTAssertEqual(details["strDrink"], "Old Fashioned")
    }
    
    func testURLSessionMockOverride() async throws {
        let mock = URLRequestMock { request in
            switch request.url!.absoluteString {
            case "www.thecocktaildb.com/api/json/v1/1/search.php?s=Old%20Fashioned":
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type" : "appliation/json"])!
                return (response, try Data(contentsOf: self.searchByCocktailNameResponseURL))
            default: return nil
            }
        }
        
        var request = URLRequest(url: URL(string: "www.thecocktaildb.com/api/json/v1/1/search.php?s=Old%20Fashioned")!)
        
        do {
            _ = try await session.data(for: request)
        } catch let error as URLError {
            XCTAssertTrue(error.code == .unsupportedURL)
            XCTAssertEqual(error.failureURLString, "www.thecocktaildb.com/api/json/v1/1/search.php?s=Old%20Fashioned")
            XCTAssertEqual(error.localizedDescription, "No mock found for \(request.url!.absoluteString)")
        } catch let error {
            XCTFail("Received unexpected error - \(error.localizedDescription)")
        }
        
        request.mock = mock
        
        let (data, response) = try await session.data(for: request)
        XCTAssertTrue((response as! HTTPURLResponse).statusCode == 200)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String : [Any]])
        let drink = try XCTUnwrap(json["drinks"]?.first as? [String : String?])
        let drinkName = try XCTUnwrap(drink["strDrink"])
        XCTAssertEqual(drinkName, "Old Fashioned")
    }
    
    func testWithNoMock() async throws {
        session = URLSession(configuration: .mock(for: .ephemeral))
        do {
            _ = try await session.data(for: URLRequest(url: URL(string: "www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11001")!))
            XCTFail("Unexpected response recieved - no mock set on URLSession")
        } catch let error as URLError {
            XCTAssertTrue(error.code == .unsupportedURL)
            XCTAssertEqual(error.failureURLString, "www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11001")
            XCTAssertEqual(error.localizedDescription, "No mock set on either URLSession or URLRequest")
        } catch let error {
            XCTFail("Received unexpected error - \(error.localizedDescription)")
        }
    }
    
}
