//
//  URLSessionConfigurationExtensions.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

extension URLSessionConfiguration {
    
    /// Creates a mock based on the given ``URLSessionConfiguration``
    ///
    /// All URLRequests is intercepted when an URLSession uses a mocked URLSessionConfiguration.
    /// There are two possible configurations. A configuration that only looks for mocks attached to URLRequests,
    /// and a configuration that uses a _global_ mock that is attached to the URLSessionConfiguration.
    ///
    /// A configuration that only looks for mocks attached to URLRequests.
    ///
    /// ````
    /// let session = URLSession(configuration: .mock(for: .ephemeral))
    /// var request = URLRequest(url: URL(string: "https://apple.com")!)
    /// request.mock = URLRequestMock { request in
    ///     return nil
    /// }
    /// ````
    ///
    /// A configuration that uses a _global_ mock that is attached to the URLSessionConfiguration.
    ///
    /// ````
    /// let mock = URLRequestMock { request in
    ///     return nil
    /// }
    ///
    /// let session = URLSession(configuration: .mock(for: .ephemeral), using: mock)
    /// ````
    ///
    /// The _global_ mock can be overriden assigning a mock to an URLRequest.
    ///
    /// - Parameter configuration: an ``URLSessionConfiguration``
    /// - Returns: A mocked ``URLSessionConfiguration``
    public class func mock(for configuration: URLSessionConfiguration, using mock: (any URLRequestMocking)? = nil) -> URLSessionConfiguration {
        configuration.protocolClasses = [URLProtocolMock.self]
        URLProtocolMock.mock = mock
        return configuration
    }
}
