//
//  LogListTableView.swift
//  Loggie
//
//  Created by Damjan Dimovski on 14.10.22.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LogListTableView: UIViewControllerRepresentable {

    public init() {}

    public typealias UIViewControllerType = UINavigationController

    public func makeUIViewController(context: Context) -> UINavigationController {
        let nav = LoggieManager.shared.showLogs()
        return nav
    }

    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
