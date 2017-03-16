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

    var logs = [Log]() {
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
        showLogDetails(with: logs[indexPath.row])
    }

    // MARK: - Private

    private func showLogDetails(with log: Log) {
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "LogDetails", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! LogDetailsViewController
        viewController.log = log
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func loggieDidUpdateLogs() {
        logs = LoggieManager.shared.logs
    }

    @objc private func closeButtonActionHandler() {
        dismiss(animated: true, completion: nil)
    }
    
}
