//
//  BaseExampleViewController.swift
//  iOSExample
//
//  Created by Mario Galijot on 27/10/2020.
//

import UIKit

class BaseExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Show Loggie",
            style: .plain,
            target: self,
            action: #selector(showLoggieBarButtonItemAction(_:))
        )
    }
    
    @objc
    private func showLoggieBarButtonItemAction(_ sender: UIBarButtonItem) {
        LoggieManager.shared.showLogs(from: self)
    }
}
