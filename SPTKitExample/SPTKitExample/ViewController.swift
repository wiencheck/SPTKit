//
//  ViewController.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 19/09/2020.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit
import SPTKit
import SPTKitModels

class ViewController: UIViewController {
    
    let manager = SpotifyManager(clientID: "your_client_id", redirectURL: URL(string: "sptkit://callback")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.login { result in
            switch result {
            case .success(let token):
                SPT.authorizationToken = token
                self.fetchArtists(with: ["6eU0jV2eEZ8XTM7EmlguK6", "7Ln80lUS6He07XvHI8qqHH"])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func fetchArtists(with ids: [String]) {
        SPT.Artists.getSeveralArtists(ids: ids) { result in
            switch result {
            case .success(let artists):
                print(artists.first?.name)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func handlePage<T>(_ page: SPTPagingObject<T>) where T: Decodable {
        print(page.items)
        
        guard page.canMakeNextRequest else {
            return
        }
        page.getNext { result in
            switch result {
            case .success(let newPage):
                self.handlePage(newPage)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension Result {
    func onSuccess(completion: @escaping (Success) -> Void) {
        guard case .success(let succ) = self else {
            return
        }
        completion(succ)
    }
    
    func onError(completion: @escaping (Failure) -> Void) {
        guard case .failure(let fail) = self else {
            return
        }
        completion(fail)
    }
}
