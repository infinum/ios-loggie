//
//  LogListTableViewController.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

class LogListTableViewController: UITableViewController {

    private static let cellReuseIdentifier = "cell"

    internal var logs = [LoggieRequest]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Logs"
        setupTableView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(closeButtonActionHandler)
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loggieDidUpdateLogs),
            name: .LoggieDidUpdateLogs,
            object: nil
        )
    }

    private func setupTableView() {
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let bundle = Bundle(for: type(of: self))
        let cellNib = UINib(nibName: "LogListTableViewCell", bundle: bundle)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogListTableViewCell
        cell.configure(with: logs[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = logs[indexPath.row]
        // show log details
    }

    // MARK: - Private

    @objc private func loggieDidUpdateLogs() {
        logs = LoggieManager.shared.logs
    }

    @objc private func closeButtonActionHandler() {
        dismiss(animated: true, completion: nil)
    }
    
}
