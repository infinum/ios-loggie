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

        let url = URL(string: "https://google.com")!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

}

extension ViewController: UIWebViewDelegate {

    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoggieManager.shared.showLogs(from: self, filter: { $0.request.url?.host == "www.google.com" })
    }
}

