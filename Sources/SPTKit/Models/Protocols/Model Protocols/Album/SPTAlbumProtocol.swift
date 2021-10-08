//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTAlbumProtocol: SPTSimplifiedAlbumProtocol {
    /**
     The copyright statements of the album.
     */
    var copyrights: [SPTCopyright] { get }
    
    /**
     A list of the genres used to classify the album. For example: "Prog Rock" , "Post-Grunge". (If not yet classified, the array is empty.)
     */
    var genres: [String] { get }
    
    /**
     The label for the album.
     */
    var label: String { get }
    
    /**
     The popularity of the album. The value will be between 0 and 100, with 100 being the most popular. The popularity is calculated from the popularity of the album’s individual tracks.
     */
    var popularity: Int { get }
    
    /**
     The tracks of the album.
     */
    var tracks: SPTPagingObject<SPTSimplifiedTrack> { get }
}
