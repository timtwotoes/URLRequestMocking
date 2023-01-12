//
//  URLRequestMockingError.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation

/// Errors that can occur during the mapping process in a mocked URLSession.
public enum URLRequestMockingError: LocalizedError {
    
    /// Mock did not recognize the request..
    case unexpectedRequest(URLRequest)
    
    /// Error message that is appropriate to show the end-user.
    public var errorDescription: String? {
        switch self {
        case .unexpectedRequest(let request):
            if let url = request.url {
                return "Could not find response for \(url.absoluteString)"
            } else {
                return "Could not find response for request"
            }
        }
    }
}
