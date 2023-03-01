//
//  AlamofireExampleViewController.swift
//  iOSExample
//
//  Created by Mario Galijot on 27/10/2020.
//

import UIKit
import Alamofire
import Loggie

final class AlamofireExampleViewController: BaseExampleViewController {
    
    private let session: Alamofire.Session = {
        return .init(eventMonitors: [EventMonitor()])
    }()

}

// MARK: - Actions

private extension AlamofireExampleViewController {

    @IBAction func performGetRequestAction(_ sender: UIButton) {
        session
            .request("https://jsonplaceholder.typicode.com/posts/1", method: .get)
            .response { (response: AFDataResponse<Data?>) in }
    }
    
    @IBAction func performPostRequestAction(_ sender: UIButton) {
        let params: [String: String] = [
            "title": "foo",
            "body": "bar",
            "userId": "1"
        ]
        
        session
            .request(
                "https://jsonplaceholder.typicode.com/posts",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default
            )
            .response { (response: AFDataResponse<Data?>) in }
    }
    
}
