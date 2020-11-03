//
//  URLSessionExampleViewController.swift
//  iOSExample
//
//  Created by Mario Galijot on 27/10/2020.
//

import UIKit

final class URLSessionExampleViewController: BaseExampleViewController {
    
    private let session: URLSession = .init(configuration: .loggie)
}

// MARK: - Actions

private extension URLSessionExampleViewController {
    
    @IBAction func performGetRequestAction(_ sender: UIButton) {
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!)
        session
            .dataTask(with: request)
            .resume()
    }
    
    @IBAction func performPostRequestAction(_ sender: UIButton) {
        let params: [String: Any] = [
            "title": "foo",
            "body": "bar",
            "userId": 1
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            
            var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts/")!)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            session
                .dataTask(with: request)
                .resume()
            
        } catch {
            print(error)
        }
    }
    
}
