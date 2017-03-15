//
//  Loggie.swift
//  Pods
//
//  Created by Filip Bec on 14/03/2017.
//
//

import UIKit

public extension URLSessionConfiguration {

    public static var loggie: URLSessionConfiguration {
        var configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(LoggieURLProtocol.self, at: 0)
        return configuration
    }
}
