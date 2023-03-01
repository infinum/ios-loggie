//
//  UIStoryboardExtensions.swift
//  Loggie
//
//  Created by Filip Stojanovski on 27.10.22.
//

import UIKit

extension UIStoryboard {

    enum LoggieIdentifier: String {
        case logDetails = "LogDetails"
    }

    func storyboard(for loggieIdentifier: LoggieIdentifier) -> UIStoryboard {
        UIStoryboard(name: loggieIdentifier.rawValue, bundle: .loggie)
    }
}
