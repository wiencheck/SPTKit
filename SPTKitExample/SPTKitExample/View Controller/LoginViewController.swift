//
//  LoginViewController.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 16/09/2021.
//  Copyright © 2021 Adam Wienconek. All rights reserved.
//

import UIKit
import SPTKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    private let manager = SpotifyManager(clientID: "your-client-id", redirectURL: URL(string: "sptkit://callback")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.login { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    SPT.authorizationToken = token
                    self.showTabBar()
                case .failure(let error):
                    self.messageLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    private func showTabBar() {
        guard let tabVc = storyboard?.instantiateViewController(identifier: "tab") else {
            fatalError()
        }
        navigationController?.setViewControllers([tabVc], animated: true)
    }
}
