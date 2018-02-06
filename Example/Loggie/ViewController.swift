//
//  ViewController.swift
//  Loggie
//
//  Created by Filip Beć on 03/12/2017.
//  Copyright (c) 2017 Filip Beć. All rights reserved.
//

import UIKit
import Loggie

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        URLProtocol.registerClass(LoggieURLProtocol.self)

        webView.delegate = self

        let url = URL(string: "https://jsonplaceholder.typicode.com/users/1")!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}

extension ViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(_ webView: UIWebView) {
        showLogs()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showLogs()
    }

    private func showLogs() {
        LoggieManager.shared.showLogs(from: self)
    }
}
