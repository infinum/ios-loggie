//
//  UITableViewExtensions.swift
//  Loggie
//
//  Created by Filip Stojanovski on 27.10.22.
//

import UIKit

extension UITableView {
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: .loggie), forCellReuseIdentifier: identifier ?? cellId)
    }
}
