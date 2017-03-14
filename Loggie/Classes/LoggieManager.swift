//
//  LoggieManager.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

internal extension Notification.Name {
    static let LoggieDidUpdateLogs = Notification.Name("co.infinum.loggie-did-update-logs")
}

public class LoggieManager: NSObject {

    public static var shared = LoggieManager()

    public private(set) var logs = [LoggieRequest]() {
        didSet {
            NotificationCenter.default.post(name: .LoggieDidUpdateLogs, object: logs)
        }
    }

    internal func add(_ request: LoggieRequest) {
        logs.append(request)
    }

    public func showLogs(from viewController: UIViewController) {
        let vc = LogListTableViewController()
        vc.logs = logs

        let navigationController = UINavigationController(rootViewController: vc)
        viewController.present(navigationController, animated: true, completion: nil)
    }

}
