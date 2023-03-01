//
//  LogListTableView.swift
//  Loggie
//
//  Created by Damjan Dimovski on 14.10.22.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LogListTableView: UIViewControllerRepresentable {

    let filter: ((Log) -> Bool)?

    public init(filter: ((Log) -> Bool)? = nil) {
        self.filter = filter
    }

    public typealias UIViewControllerType = UINavigationController

    public func makeUIViewController(context: Context) -> UINavigationController {
        return LoggieManager.shared.showLogs(filter: filter)
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
