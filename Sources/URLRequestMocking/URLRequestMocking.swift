//
//  URLRequestMocking.swift
//
//
//  Created by Tim Wolff on 08/01/2023.
//

import Foundation

/// Implementor of this protocol, must return a response based on the given request.
public protocol URLRequestMocking {
    
    /// Produces a response for a given request. If no response is returned, a default response will be returned to URLSession.
    /// - Parameter request: An URL request.
    /// - Returns: Returns a simulated response from server or nil.
    /// - Throws: Can throw an error to simulate network error conditions.
    func response(for request: URLRequest) throws -> (response: URLResponse, data: Data)?
}
