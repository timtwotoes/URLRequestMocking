//
//  URLSessionConfigurationExtensions.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

extension URLSessionConfiguration {
    public class func mock(for configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        configuration.protocolClasses = [URLProtocolMock.self]
        return configuration
    }
}
