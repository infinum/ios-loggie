//
//  LogListTableViewController.swift
//  Pods
//
//  Created by Filip Bec on 12/03/2017.
//
//

import UIKit

public class LogListTableViewController: UITableViewController {

    // MARK: - Properties
    
    private static let cellReuseIdentifier = "cell"

    private var logs: [Log] = []

    public var filter: ((Log) -> Bool)? = nil {
        didSet {
            updateLogs()
        }
    }
    
    private var searchText: String?
    
    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Logs"
        setupUI()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loggieDidUpdateLogs),
            name: .LoggieDidUpdateLogs,
            object: nil
        )
        
        updateLogs()
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogListTableViewController.cellReuseIdentifier, for: indexPath) as! LogListTableViewCell
        cell.configure(with: logs[indexPath.row])
        return cell
    }

    // MARK: - Table view delegate

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LogDetails", bundle: .loggie)
        let viewController = storyboard.instantiateInitialViewController() as! LogDetailsViewController
        viewController.log = logs[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Private

    private func updateLogs() {
        let _logs: [Log] = LoggieManager.shared.logs.reversed()
        if let filter = filter {
            logs = _logs.filter(filter)
        } else {
            logs = _logs
        }
        
        if let searchText = self.searchText {
            logs = logs.filter { $0.request.url?.absoluteString.lowercased().contains(searchText) ?? false }
        }
        
        if Thread.isMainThread {
            tableView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UI

private extension LogListTableViewController {
    
    func setupUI() {
        setupDismissButton()
        setupSearchBar()
        setupTableView()
    }
    
    func setupDismissButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(closeButtonActionHandler)
        )
    }
    
    func setupSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        searchBar.placeholder = "Search by URL"
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
    }
    
    func setupTableView() {
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let cellNib = UINib(nibName: "LogListTableViewCell", bundle: .loggie)
        tableView.register(cellNib, forCellReuseIdentifier: LogListTableViewController.cellReuseIdentifier)
    }
}

// MARK: - Actions

private extension LogListTableViewController {
    
    @objc func loggieDidUpdateLogs() {
        updateLogs()
    }

    @objc func closeButtonActionHandler() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate

extension LogListTableViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText.isEmpty ? nil : searchText.lowercased()
        updateLogs()
    }
}
