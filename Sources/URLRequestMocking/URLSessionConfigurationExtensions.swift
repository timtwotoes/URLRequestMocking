//
//  URLSessionConfigurationExtensions.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

extension URLSessionConfiguration {
    
    /// Creates a mock based on the given ``URLSessionConfiguration``
    /// - Parameter configuration: an ``URLSessionConfiguration``
    /// - Returns: A mocked ``URLSessionConfiguration``
    public class func mock(for configuration: URLSessionConfiguration, using mock: (any URLRequestMocking)? = nil) -> URLSessionConfiguration {
        configuration.protocolClasses = [URLProtocolMock.self]
        URLProtocolMock.mock = mock
        return configuration
    }
}
