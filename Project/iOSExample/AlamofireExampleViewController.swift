//
//  AlamofireExampleViewController.swift
//  iOSExample
//
//  Created by Mario Galijot on 27/10/2020.
//

import UIKit
import Alamofire

final class AlamofireExampleViewController: BaseExampleViewController {
    
    private let session: Alamofire.Session = {
        return .init(eventMonitors: [EventMonitor()])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Actions

private extension AlamofireExampleViewController {

    @IBAction func performGetRequestAction(_ sender: UIButton) {
        session
            .request("https://jsonplaceholder.typicode.com/posts/", method: .get)
            .responseJSON { (response: AFDataResponse<Any>) in
                
            }
    }
    
    @IBAction func performPostRequestAction(_ sender: UIButton) {
        
    }
    
}
