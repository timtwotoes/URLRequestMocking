//
//  URLRequestMock.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

public struct URLRequestMock: URLRequestMocking {
    private let mock: (URLRequest) -> (response: URLResponse, data: Data)
    public init(@URLResponseBuilder _ builder: @escaping (URLRequest) -> (response: URLResponse, data: Data)) {
        mock = builder
    }
    
    public func response(for request: URLRequest) throws -> (response: URLResponse, data: Data)? {
        return mock(request)
    }
}

@resultBuilder
public enum URLResponseBuilder {
    public static func buildBlock(_ response: URLResponse, _ data: Data) -> (response: URLResponse, data: Data) {
        return (response, data)
    }
    
}
