//
//  ViewController.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 19/09/2020.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit
import SPTKit

class TracksViewController: UITableViewController {
        
    var newTracks: [SPTTrack] = []
    var tracks: [SPTTrack] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard tracks.isEmpty else { return }
        
        loadTracks { error in
            if let error = error {
                print(error)
                return
            }
            self.tracks = self.newTracks
            self.newTracks.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadTracks(completion: @escaping (Error?) -> Void) {
        SPT.Library.getSavedTracks { [weak self] result in
            switch result {
            case .success(let firstPage):
                self?.handlePage(firstPage, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func handlePage(_ page: SPTPagingObject<SPTSavedTrack>, completion: ((Error?) -> Void)?) {
        
        print("Page offset: \(page.offset), items: \(type(of: page.items))")
        newTracks.append(contentsOf: page.items.map(\.track))
        
        guard page.canMakeNextRequest else {
            completion?(nil)
            return
        }
        page.getNext { [weak self] result in
            switch result {
            case .success(let newPage):
                self?.handlePage(newPage, completion: completion)
            case .failure(let error):
                completion?(error)
            }
        }
    }
}

extension TracksViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.name
        cell.detailTextLabel?.text = track.artists.first?.name
        cell.imageView?.image = nil
        
        return cell
    }
}
