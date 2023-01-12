//
//  File.swift
//  
//
//  Created by Tim on 12/01/2023.
//

import Foundation
import URLProtocolExtensions

extension URLRequest {
    
    /// A mock that handles this request.
    ///
    /// - Precondition: URLSession must be configured with a mock configuration before this works.
    public var mock: (any URLRequestMocking)? {
        get {
            return URLProtocol.property(forKey: "URLRequestMocking", in: self) as? URLRequestMocking
        }
        set (newValue) {
            if let mock = newValue {
                URLProtocol.setProperty(mock, forKey: "URLRequestMocking", in: &self)
            } else {
                URLProtocol.removeProperty(forKey: "URLRequestMocking", in: &self)
            }
        }
    }
}
