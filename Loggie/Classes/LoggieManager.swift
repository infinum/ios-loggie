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

    public private(set) var logs = [Log]() {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .LoggieDidUpdateLogs, object: self.logs)
            }
        }
    }

    internal func add(_ log: Log) {
        logs.insert(log, at: 0)
    }

    public func showLogs(from viewController: UIViewController) {
        let vc = LogListTableViewController()
        vc.logs = logs

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isTranslucent = false
        viewController.present(navigationController, animated: true, completion: nil)
    }

}
