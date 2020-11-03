//
//  LoggieURLProtocol.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LoggieURLProtocol: URLProtocol {

    // MARK: - Properties
    
    private static let HeaderKey = "Loggie"
    
    private var dataTask: URLSessionDataTask?

    // MARK: - URLProtocol Overrides
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return property(forKey: LoggieURLProtocol.HeaderKey, in: request) == nil
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }

    public override func startLoading() {
        var request = LoggieURLProtocol.canonicalRequest(for: self.request)
        
        if let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            LoggieURLProtocol.setProperty(true, forKey: LoggieURLProtocol.HeaderKey, in: mutableRequest)
            request = mutableRequest as URLRequest
        }
        
        let log = Log(request: request)
        log.startTime = Date()

        let session: URLSession = LoggieManager.shared.urlSessionFor(urlRequest: request)
        
        dataTask = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let `self` = self else { return }

            log.endTime = Date()
            log.error = error
            log.data = data
            log.response = response as? HTTPURLResponse
            LoggieManager.shared.add(log)
            
            guard let client = self.client else { return }

            if let error = error {
                client.urlProtocol(self, didFailWithError: error)
            } else if let response = response {
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = data {
                client.urlProtocol(self, didLoad: data)
            }
            
            client.urlProtocolDidFinishLoading(self)
        })
        dataTask?.resume()
    }

    public override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
    }
}

private extension LoggieManager {
    
    func urlSessionFor(urlRequest: URLRequest) -> URLSession {
        return delegate?.loggie(self, urlSessionForURLRequest: urlRequest) ?? defaultURLSession
    }
}

// MARK: - Loggie + URLSessionConfiguration

public extension URLSessionConfiguration {
    
    /// `URLSessionConfiguration.default`, modified in a way that its `protocolClasses`
    /// contains `LoggieURLProtocol` at the first index.
    @objc(loggieSessionConfiguration)
    static var loggie: URLSessionConfiguration {
        return loggie(combinedWith: .default)
    }
    
    /// Returns the modified session configuration provided in the method, modified in a way that its `protocolClasses`
    /// contains `LoggieURLProtocol` at the first index.
    ///
    /// If you just want to use simple form of configuration, use the provided `loggie` configuration.
    @objc(loggieSessionConfigurationCombinedWith:)
    static func loggie(combinedWith configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        if configuration.protocolClasses == nil {
            configuration.protocolClasses = [LoggieURLProtocol.self]
        } else {
            configuration.protocolClasses?.insert(LoggieURLProtocol.self, at: 0)
        }
        return configuration
    }
}
