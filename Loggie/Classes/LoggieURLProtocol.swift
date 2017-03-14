//
//  LoggieURLProtocol.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LoggieURLProtocol: URLProtocol {

    private static let HeaderKey = "Loggie"

    private var connection: NSURLConnection?

    fileprivate var loggieManager = LoggieManager.shared
    fileprivate var loggieRequest: LoggieRequest?

    // MARK: - URLProtocol

    public override class func canInit(with request: URLRequest) -> Bool {
        guard property(forKey: LoggieURLProtocol.HeaderKey, in: request) == nil else {
            return false
        }
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }

    public override func startLoading() {
        guard let request = request as? NSMutableURLRequest else {
            return
        }
        LoggieURLProtocol.setProperty(true, forKey: LoggieURLProtocol.HeaderKey, in: request)
        connection = NSURLConnection(request: request as URLRequest, delegate: self)

        loggieRequest = LoggieRequest(request: request as URLRequest)
        loggieRequest?.startTime = Date()
    }

    public override func stopLoading() {
        connection?.cancel()
        connection = nil
    }

}

extension LoggieURLProtocol: NSURLConnectionDataDelegate {

    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let httpUrlResponse = response as? HTTPURLResponse {
            loggieRequest?.response = httpUrlResponse
        }
    }

    public func connection(_ connection: NSURLConnection, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        if loggieRequest?.data == nil {
            loggieRequest?.data = data
        } else {
            loggieRequest?.data?.append(data)
        }
    }

    public func connectionDidFinishLoading(_ connection: NSURLConnection) {
        client?.urlProtocolDidFinishLoading(self)
        loggieRequest?.endTime = Date()
        logRequest()
    }

    public func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
        loggieRequest?.error = error
        loggieRequest?.endTime = Date()
        logRequest()
    }

    private func logRequest() {
        if let request = loggieRequest {
            loggieManager.add(request)
        }
    }

}
