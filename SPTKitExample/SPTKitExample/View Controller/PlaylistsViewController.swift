//
//  PlaylistsViewController.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 25/09/2021.
//  Copyright © 2021 Adam Wienconek. All rights reserved.
//

import UIKit
import SPTKit


class PlaylistsViewController: UITableViewController {
        
    var newPlaylists: [SPTPlaylist] = []
    var playlists: [SPTPlaylist] = []
    private var selectedIndexPath: IndexPath?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard playlists.isEmpty else { return }
        
        loadPlaylists { error in
            if let error = error {
                print(error)
                return
            }
            self.playlists = self.newPlaylists
            self.newPlaylists.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadPlaylists(completion: @escaping (Error?) -> Void) {
        SPT.Library.getFollowedPlaylists { result in
            switch result {
            case .success(let firstPage):
                self.handlePage(firstPage, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func handlePage(_ page: SPTPagingObject<SPTPlaylist>, completion: ((Error?) -> Void)?) {
        
        print("Page offset: \(page.offset), items: \(type(of: page.items))")
        newPlaylists.append(contentsOf: page.items)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let indexPath = selectedIndexPath,
           let destination = segue.destination as? PlaylistTracksViewController {
            destination.playlistId = playlists[indexPath.row].id
        }
    }
}

extension PlaylistsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        let playlist = playlists[indexPath.row]
        cell.textLabel?.text = playlist.name
        cell.detailTextLabel?.text = playlist.owner.displayName
        cell.imageView?.image = nil
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "playlistTracksSegue", sender: nil)
    }
}
