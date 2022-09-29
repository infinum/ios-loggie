//
//  LoggieManager.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

extension Notification.Name {
    static let LoggieDidUpdateLogs = Notification.Name("com.infinum.loggie-did-update-logs")
}

@objc
public protocol LoggieDelegate {
    
    /// Asks a delegate to provide a `URLRequest`-specific `URLSession`,
    /// using which a `Loggie` will be able to perform a `URLSessionTask`.
    ///
    /// Most of the apps tipically manage networking logic in one class, such as `Alamofire`'s `SessionManager`,
    /// which is ideal place for implementing this protocol.
    /// If you don't conform to this protocol & implement this method, `Loggie` will create (& retain) it's own `URLSession`,
    /// instantiated with a `URLSessionConfiguration.default`.
    ///
    /// - Parameters:
    ///   - loggie: An instance of a `LoggieManager` that is asking for a `URLSession` object.
    ///   - urlRequest: `URLRequest` for which which a `Loggie` needs a `URLSession` which will execute it.
    func loggie(_ loggie: LoggieManager, urlSessionForURLRequest urlRequest: URLRequest) -> URLSession
}

@objcMembers
public final class LoggieManager: NSObject {
    
    // MARK: - Properties
    
    /// A **serial** queue, on which Loggie is appending new logs & posting a notification that `logs` have changed.
    private let logsHandlingQueue: DispatchQueue = .init(label: "com.infinum.loggie-logs-handling-queue")
    
    /// An instance of `URLSession` which Loggie is using if there's no delegate to provide his own session.
    ///
    /// Used only for `LoggieURLProtocol`.
    lazy var defaultURLSession: URLSession = .init(configuration: .default)
    
    /// A delegate used to provide a `URLSession` instance, using which Loggie will perform data requests.
    ///
    /// This delegate is used **only** when you're working with `LoggieURLProtocol`, through `Loggie/URLSession` pod.
    /// Assigning a value to this property when working with `EventMonitor` has no impact & isn't used at all,
    /// but won't affect the usage anyhow.
    ///
    /// You should assign this delegate as soon as the app starts, so Loggie could use your, instead of Loggie's default, `URLSession` instance.
    public weak var delegate: LoggieDelegate?
    
    /// An array containing all `Log`s either being performed by Loggie through `LoggieURLProtocol`,
    /// or observer by loggie through `EventMonitor`.
    public private(set) var logs: [Log] = []
    
    @objc(sharedManager)
    public static let shared = LoggieManager()
    
    @discardableResult
    @objc(showLogsFromViewController:filter:)
    public func showLogs(from viewController: UIViewController, filter: ((Log) -> Bool)? = nil) -> UINavigationController {
        let vc = LogListTableViewController()
        vc.filter = filter
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isTranslucent = false
        viewController.present(navigationController, animated: true, completion: nil)
        return navigationController
    }
    
    public func add(_ log: Log) {
        // Avoid changing logs array from multiple threads (race condition)
        logsHandlingQueue.async { [weak self] in
            guard let self = self else { return }
            self.logs.append(log)
            NotificationCenter.default.post(name: .LoggieDidUpdateLogs, object: self.logs)
        }
    }
}
