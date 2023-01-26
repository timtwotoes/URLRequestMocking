//
//  URLProtocolMock.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

class URLProtocolMock: URLProtocol {
    
    internal struct ExceptionMock: URLRequestMocking {
        func response(for request: URLRequest) throws -> (response: URLResponse, data: Data)? {
            throw URLRequestMockingError.unexpectedRequest(request)
        }
    }
    
    internal static var mock: (any URLRequestMocking)?
    
    override public class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    public let mock: any URLRequestMocking

    override public init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        if request.mock != nil {
            mock = request.mock!
        } else if URLProtocolMock.mock != nil {
            mock = URLProtocolMock.mock!
        } else {
            mock = ExceptionMock()
        }
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        do {
            if let response = try mock.response(for: request) {
                client?.urlProtocol(self, didReceive: response.response , cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: response.data)
                client?.urlProtocolDidFinishLoading(self)
            } else {
                client?.urlProtocol(self, didFailWithError: URLRequestMockingError.unexpectedRequest(request))
            }
        } catch let error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override public func stopLoading() {
        
    }
}
