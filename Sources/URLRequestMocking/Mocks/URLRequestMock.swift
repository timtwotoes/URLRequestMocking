//
//  URLRequestMock.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

public struct URLRequestMock: URLRequestMocking {
    public typealias Response = (response: URLResponse, data: Data)
    private let mock: (URLRequest) -> Response?
    public init(_ builder: @escaping (URLRequest) -> Response?) {
        mock = builder
    }
    
    public func response(for request: URLRequest) throws -> (response: URLResponse, data: Data)? {
        return mock(request)
    }
}
