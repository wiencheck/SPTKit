//
//  ViewController.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 19/09/2020.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit
import SPTKit

class AlbumsViewController: UITableViewController {
        
    var newAlbums: [SPTAlbum] = []
    var albums: [SPTAlbum] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard albums.isEmpty else { return }
        
        loadAlbums { error in
            if let error = error {
                print(error)
                return
            }
            self.albums = self.newAlbums
            self.newAlbums.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadAlbums(completion: @escaping (Error?) -> Void) {
        SPT.Library.getSavedAlbums { result in
            switch result {
            case .success(let firstPage):
                self.handlePage(firstPage, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func handlePage(_ page: SPTPagingObject<SPTSavedAlbum>, completion: ((Error?) -> Void)?) {
        
        print("Page offset: \(page.offset), items: \(type(of: page.items))")
        newAlbums.append(contentsOf: page.items.map(\.album))
        
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

extension AlbumsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artists.first?.name
        cell.imageView?.image = nil
        
        return cell
    }
}
