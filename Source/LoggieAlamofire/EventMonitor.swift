//
//  EventMonitor.swift
//  LoggieAlamofire
//
//  Created by Mario Galijot on 23/10/2020.
//

import Alamofire

/// An event monitor through which Loggie is able to track requests being performed.
public final class EventMonitor: Alamofire.EventMonitor {
    
    public var queue: DispatchQueue { return .init(label: "com.infinum.loggie-event-monitor-queue") }
    
    public init() {}

    public func request(_ request: Request, didGatherMetrics metrics: URLSessionTaskMetrics) {
        /// we're handling only `DataRequest`s for now
        guard let dataRequest = request as? DataRequest else { return }
        
        for metric in metrics.transactionMetrics {
            let log = Log(request: metric.request)
            log.startTime = metric.fetchStartDate ?? metric.connectStartDate ?? metric.requestStartDate
            log.endTime = metric.responseEndDate ?? metric.requestEndDate
            
            log.data = dataRequest.data
            log.error = dataRequest.error
            log.response = metric.response as? HTTPURLResponse
            LoggieManager.shared.add(log)
        }
    }
}
