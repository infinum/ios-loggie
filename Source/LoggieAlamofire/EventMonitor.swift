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
    
    /// Logs currently being processed.
    ///
    /// After a request is performd, it's respective `Log` will be created & stored in this array.
    /// After request completes successfully or fails with an error, `Log` will be updated & forwarded to the `LoggieManager`.
    private var activeLogs: [Log] = []
    
    public init() {}
    
    public func requestDidFinish(_ request: Request) {
        
    }
    
    public func request(_ request: Request, didResumeTask task: URLSessionTask) {
        // will check this later
        guard let urlRequest = request.request else { return }
        let log: Log = .init(request: urlRequest)
        log.startTime = Date()
        activeLogs.append(log)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard
            let urlRequest = task.currentRequest,
            let log = activeLogs.first(where: { $0.request == urlRequest })
        else { return }
        
        log.endTime = Date()
        log.error = error
        log.response = task.response as? HTTPURLResponse
        LoggieManager.shared.add(log)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard
            let urlRequest = dataTask.currentRequest,
            let log = activeLogs.first(where: { $0.request == urlRequest })
        else { return }
        
        log.endTime = Date()
        log.data = data
        log.response = dataTask.response as? HTTPURLResponse
        LoggieManager.shared.add(log)
    }
}
