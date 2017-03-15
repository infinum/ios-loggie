//
//  LoggieURLProtocol.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LoggieURLProtocol: URLProtocol {

    private var connection: NSURLConnection?

    fileprivate static let HeaderKey = "Loggie"

    fileprivate var loggieManager = LoggieManager.shared
    fileprivate var log: Log?

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

        log = Log(request: request as URLRequest)
        log?.startTime = Date()
    }

    public override func stopLoading() {
        connection?.cancel()
        connection = nil
    }

}

extension LoggieURLProtocol: NSURLConnectionDataDelegate {

    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        if let httpUrlResponse = response as? HTTPURLResponse {
            log?.response = httpUrlResponse
        }
    }

    public func connection(_ connection: NSURLConnection, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        if log?.data == nil {
            log?.data = data
        } else {
            log?.data?.append(data)
        }
    }

    public func connectionDidFinishLoading(_ connection: NSURLConnection) {
        client?.urlProtocolDidFinishLoading(self)
        log?.endTime = Date()
        saveLog()
    }

    public func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
        log?.error = error
        log?.endTime = Date()
        saveLog()
    }

    public func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        guard let _request = request as? NSMutableURLRequest, let _response = response else {
            return request
        }

        LoggieURLProtocol.removeProperty(forKey: LoggieURLProtocol.HeaderKey, in: _request)
        client?.urlProtocol(self, wasRedirectedTo: _request as URLRequest, redirectResponse: _response)
        return _request as URLRequest
    }

    private func saveLog() {
        if let log = log {
            loggieManager.add(log)
        }
    }

}
