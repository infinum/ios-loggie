//
//  LoggieRequest.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LoggieRequest: NSObject {

    public var request: URLRequest
    public var response: HTTPURLResponse?
    public var data: Data?
    public var error: Error?

    public var startTime: Date?
    public var endTime: Date?

    public var duration: TimeInterval? {
        guard let start = startTime, let end = endTime else {
            return nil
        }
        return end.timeIntervalSince(start)
    }

    public init(request: URLRequest) {
        self.request = request
    }
}
