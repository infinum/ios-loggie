//
//  LoggieURLProtocol.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LoggieURLProtocol: URLProtocol {

    private var dataTask: URLSessionDataTask?

    private static let HeaderKey = "Loggie"

    private var loggieManager = LoggieManager.shared
    private var log: Log?

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
        let canonicalRequest = LoggieURLProtocol.canonicalRequest(for: request)
        let mutableRequest = (canonicalRequest as NSURLRequest).mutableCopy() as! NSMutableURLRequest

        LoggieURLProtocol.setProperty(true, forKey: LoggieURLProtocol.HeaderKey, in: mutableRequest)

        log = Log(request: mutableRequest as URLRequest)
        log?.startTime = Date()

        let session = URLSession(configuration: URLSessionConfiguration.default)
        dataTask = session.dataTask(with: (mutableRequest as URLRequest), completionHandler: { (data, response, error) in
            self.log?.endTime = Date()
            self.log?.error = error
            self.log?.data = data
            self.log?.response = response as? HTTPURLResponse

            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = data {
                self.client!.urlProtocol(self, didLoad: data)
            }

            self.client?.urlProtocolDidFinishLoading(self)
            self.saveLog()
        })
        dataTask?.resume()
    }

    public override func stopLoading() {
        dataTask?.cancel()
        dataTask = nil
    }

    private func saveLog() {
        if let log = log {
            loggieManager.add(log)
        }
    }

}
