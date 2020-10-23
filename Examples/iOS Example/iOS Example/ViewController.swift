//
//  ViewController.swift
//  iOS Example
//
//  Created by Mario Galijot on 23/10/2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
    }
}

extension ViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(type(of: object))
            print(object)
        } catch let error {
            print(error)
        }
    }
}
