//
//  LogListTableViewController.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LogListTableViewController: UITableViewController {

    private static let cellReuseIdentifier = "cell"
    internal var logsDataSourceDelegate: LogsDataSourceDelegate!

    @IBOutlet private var searchBar: UISearchBar!

    private var isSearching = false
    private var logs = [Log]() {
        didSet {
            guard isSearching == false else { return }
            tableView.reloadData()
        }
    }
    private var searchResult = [Log]()
    private var dataSource: [Log] {
        return isSearching ? searchResult : logs
    }

    public var filter: ((Log) -> Bool)? = nil {
        didSet {
            updateLogs()
        }
    }

    override public func viewDidLoad() {
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
        updateLogs()
    }

    private func setupTableView() {
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let cellNib = UINib(nibName: "LogListTableViewCell", bundle: .loggie)
        tableView.register(cellNib, forCellReuseIdentifier: LogListTableViewController.cellReuseIdentifier)
    }

    @IBAction func clearAction() {
        logsDataSourceDelegate.clearLogs()
        logs = []
        searchResult = []
    }
}

// MARK: - Table view data source

extension LogListTableViewController {

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LogListTableViewController.cellReuseIdentifier,
            for: indexPath
        ) as! LogListTableViewCell

        cell.configure(with: dataSource[indexPath.row])
        return cell
    }
}

// MARK: - Table view delegate

extension LogListTableViewController {

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLogDetails(with: dataSource[indexPath.row])
    }

    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}
// MARK: - Search bar delegate

extension LogListTableViewController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = searchText.isEmpty == false
        guard isSearching else {
            searchResult = []
            tableView.reloadData()
            return
        }
        searchResult = logs.filter({ $0.searchableText.range(of: searchText, options: .caseInsensitive) != nil })
        tableView.reloadData()
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Private

extension LogListTableViewController {

    private func updateLogs() {
        let _logs: [Log] = LoggieManager.shared.logs.reversed()
        if let filter = filter {
            logs = _logs.filter(filter)
        } else {
            logs = _logs
        }
    }

    private func showLogDetails(with log: Log) {
        let storyboard = UIStoryboard(name: "LogDetails", bundle: .loggie)
        let viewController = storyboard.instantiateInitialViewController() as! LogDetailsViewController
        viewController.log = log
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func loggieDidUpdateLogs() {
        updateLogs()
    }

    @objc private func closeButtonActionHandler() {
        dismiss(animated: true, completion: nil)
    }
}
