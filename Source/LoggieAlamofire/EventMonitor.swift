//
//  EventMonitor.swift
//  LoggieAlamofire
//
//  Created by Mario Galijot on 23/10/2020.
//

import Alamofire
import Foundation

/// An event monitor through which Loggie is able to track requests being performed.
public final class EventMonitor: Alamofire.EventMonitor {
    
    public var queue: DispatchQueue { return .init(label: "com.infinum.loggie-event-monitor-queue") }

    public init() {}

    public func request(_ request: Request, didGatherMetrics metrics: URLSessionTaskMetrics) {
        /// we're handling only `DataRequest`s for now
        guard let dataRequest = request as? DataRequest, let urlRequest = dataRequest.request else { return }

        for metric in metrics.transactionMetrics {
            guard let startTime = metric.requestStartDate, let endTime = metric.responseEndDate else { return }

            let log = Log(request: urlRequest)
            log.startTime = startTime
            log.endTime = endTime
            log.data = dataRequest.data
            log.error = dataRequest.error
            log.response = metric.response as? HTTPURLResponse
            // For some reason, the request that is collected only has a handful of headers available. To make this a bit more verbose,
            // we're attaching headers from the metric which has a lot more information about the request.
            log.request.headers = metric.request.headers

            LoggieManager.shared.add(log)
        }
    }
}
