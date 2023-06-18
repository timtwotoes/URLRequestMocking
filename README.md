# URLRequestMocking

Create mocks for URLSession. A quick solution for testing network requests in a controlled environment.

## Usage

You can either attach a mock to the URLRequest or the URLSessionConfiguration.

Following example illustrates how to attach a mock to an URLRequest
 
```swift
import URLRequestMocking

// Create mock for an URLSession
let session = URLSession(configuration: .mock(for: .ephemeral)

// Create URLRequest normally
let request = URLRequest(url: URL(string: "https://example.com")!)

// Attach mock using helper class URLRequestMock
request.mock = URLRequestMock { request in
    // Evaluate request
    if request.url!.absoluteString == "https://example.com" {
        // return (URLResponse, Data) tuple however you want to reply
    }
}

// Call URLSession as you normally would
let (data, response) = try await session.data(for: request)
```

Following example illustrates how to attach a mock to an URLSession through the URLSessionConfiguration object.

```swift
import URLRequestMocking

// Attach mock to URLSession through URLSessionConfiguration
let session = URLSession(configuration: .mock(for: .ephemeral, using: URLRequestMock { request in
    // Evaluate request
    if request.url!.absoluteString == "https://example.com" {
        // return (URLResponse, Data) tuple however you want to reply
    }    
}))

// Call URLSession as you normally would
let (data, response) = try await session.data(for: URLRequest(url: URL(string: "https://example.com")!))

```

If a mock is attached to the URLSessionConfiguration object and the URLRequest, the URLRequest will override the
mock on the URLSession.

Creating a mocked URLSession without attaching any mock on either URLSessionConfiguration or the URLRequest will
result in an URLError exception, when the request is sent throught the URLSession.

## Limitations

Setting a mock on the URLSessionConfiguration can only be done for a single URLSession per thread.
Creating two URLSessionConfiguration objects with two different mocks, will override the mock on the
first URLSessionConfiguration.

## Requirements

macOS 11 (Big Sur) or iOS 14
Swift 5.7
