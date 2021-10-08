//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTPlaylistProtocol: SPTSimplifiedPlaylistProtocol {
    /**
     Information about the followers of the playlist.
     */
    var followers: SPTFollowers { get }
}
