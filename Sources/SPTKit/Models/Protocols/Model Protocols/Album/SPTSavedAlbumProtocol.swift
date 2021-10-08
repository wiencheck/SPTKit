//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTSavedAlbumProtocol: Decodable {
    /**
     The date and time the album was saved.
     */
    var addedDate: Date { get }
    
    /**
     Information about the album.
     */
    var album: SPTAlbum { get }
}
