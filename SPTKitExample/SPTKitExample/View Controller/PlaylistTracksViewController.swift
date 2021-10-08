//
//  PlaylistTracksViewController.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 29/09/2021.
//  Copyright © 2021 Adam Wienconek. All rights reserved.
//

import UIKit
import SPTKit

class PlaylistTracksViewController: UITableViewController {
    
    var playlistId: String!
    private var playlist: SPTPlaylist!
    
    private var tracks: [SPTTrack] = []
    private var newTracks: [SPTPlaylistTrack] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard playlist == nil else { return }
        
        /* Get full details about playlist */
        SPT.Playlists.getPlaylist(id: playlistId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlist):
                    self.playlist = playlist
                    self.tableView.reloadData()
                    
                    self.loadFreshData(forPlaylist: playlist)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadFreshData(forPlaylist playlist: SPTPlaylist) {
        tableView.showsVerticalScrollIndicator = false
        fetchPlaylistTracks { error in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.showsVerticalScrollIndicator = true
            }
        }
    }
    
    private func handlePage(_ page: SPTPagingObject<SPTPlaylistTrack>, completion: ((Error?) -> Void)?) {
        print("Page offset: \(page.offset), items: \(type(of: page.items))")
        newTracks.append(contentsOf: page.items)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            guard page.canMakeNextRequest else {
                completion?(nil)
                return
            }
            page.getNext { result in
                switch result {
                case .success(let newPage):
                    self.handlePage(newPage, completion: completion)
                case .failure(let error):
                    completion?(error)
                }
            }
        }
    }
    
    private func fetchPlaylistTracks(completion: @escaping (Error?) -> Void) {
        func fetchTracks(from playlist: SPTPlaylist, completion: @escaping (Error?) -> Void) {
            let playlistId = playlist.id
            SPT.Playlists.getPlaylistTracks(id: playlistId) { result in
                switch result {
                case .success(let page):
                    self.handlePage(page, completion: completion)
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        fetchTracks(from: playlist, completion: completion)
    }
    
}

extension PlaylistTracksViewController {
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

