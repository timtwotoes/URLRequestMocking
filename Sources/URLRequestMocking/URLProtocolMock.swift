//
//  URLProtocolMock.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation
import OSLog

internal final class URLProtocolMock: URLProtocol {
    private let log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "mock")
    
    internal struct ExceptionMock: URLRequestMocking {
        func response(for request: URLRequest) throws -> (response: URLResponse, data: Data)? {
            var userInfo = [String : Any]()
            userInfo[NSURLErrorFailingURLErrorKey] = request.url!
            userInfo[NSURLErrorFailingURLStringErrorKey] = request.url!.absoluteString
            userInfo[NSLocalizedDescriptionKey] = "No mock set on either URLSession or URLRequest"
            throw URLError(.unsupportedURL, userInfo: userInfo)
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
                log.debug("Sending response for \(self.request.url!.absoluteString, privacy: .public)")
                client?.urlProtocol(self, didReceive: response.response , cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: response.data)
                client?.urlProtocolDidFinishLoading(self)
            } else {
                var userInfo = [String : Any]()
                userInfo[NSURLErrorFailingURLErrorKey] = request.url!
                userInfo[NSURLErrorFailingURLStringErrorKey] = request.url!.absoluteString
                userInfo[NSLocalizedDescriptionKey] = "No mock found for \(request.url!.absoluteString)"

                log.debug("No mock found for \(self.request.url!.absoluteString, privacy: .public)")
                client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL, userInfo: userInfo))
            }
        } catch let error {
            log.debug("Error loading \(self.request.url!.absoluteString, privacy: .public)")
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override public func stopLoading() {
        
    }
}
