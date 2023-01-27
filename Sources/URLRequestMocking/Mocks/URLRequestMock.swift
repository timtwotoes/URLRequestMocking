//
//  URLRequestMock.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

/// A convienience implementation of URLRequestMocking protocol. Instead of creating a new struct
/// that conforms to the URLRequestMocking protocol, this implementation allows the user to create a
/// mock using a closure.
public struct URLRequestMock: URLRequestMocking {
    public typealias Response = (response: URLResponse, data: Data)
    
    private let mock: (URLRequest) -> Response?
    
    /// Constructor that creates a mock from a closure.
    ///
    /// Based on the URLRequest input a tuple containing an URLResponse and a Data structure must
    /// be returned.
    ///
    /// ````
    /// let mock = URLRequestMock { request in
    ///     if request.url?.absoluteString == "https://example.com" {
    ///         let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    ///         return (response, "Success".data(using: .utf8)!)
    ///     } else {
    ///         return nil
    ///     }
    /// }
    /// ````
    ///
    /// If nil is returned, meaning no response is returned, the URLSession will throw an URLRequestMockingError.
    ///
    /// - Parameter builder: a closure that produces a response from an URLRequest.
    public init(_ builder: @escaping (URLRequest) -> Response?) {
        mock = builder
    }
    
    public func response(for request: URLRequest) throws -> (response: URLResponse, data: Data)? {
        return mock(request)
    }
}
