//
//  URLSessionExampleViewController.swift
//  iOSExample
//
//  Created by Mario Galijot on 27/10/2020.
//

import UIKit

final class URLSessionExampleViewController: BaseExampleViewController {
    
    private let session: URLSession = .shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoggieManager.prepare()
    }
}

// MARK: - Actions

private extension URLSessionExampleViewController {

    @IBAction func performGetRequestAction(_ sender: UIButton) {
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/")!)
        session
            .dataTask(with: request)
            .resume()
    }
    
    @IBAction func performPostRequestAction(_ sender: UIButton) {
        
    }
    
}
