//
//  LoggieManager.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

extension Notification.Name {
    static let LoggieDidUpdateLogs = Notification.Name("co.infinum.loggie-did-update-logs")
}

public class LoggieManager: NSObject {

    @objc(sharedManager)
    public static let shared = LoggieManager()

    public private(set) var logs = [Log]() {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .LoggieDidUpdateLogs, object: self.logs)
            }
        }
    }

    private override init() {}

    @objc(showLogsFromViewController:)
    public func showLogs(from viewController: UIViewController) {
        let vc = LogListTableViewController()
        vc.logs = logs

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isTranslucent = false
        viewController.present(navigationController, animated: true, completion: nil)
    }

    func add(_ log: Log) {
        logs.insert(log, at: 0)
    }

}
