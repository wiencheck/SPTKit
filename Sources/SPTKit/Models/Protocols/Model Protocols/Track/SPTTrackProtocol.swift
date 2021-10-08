//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTTrackProtocol: SPTSimplifiedTrackProtocol {
    /**
     The album on which the track appears
     */
    var album: SPTSimplifiedAlbum { get }
    
    /**
     The popularity of the track. The value will be between 0 and 100, with 100 being the most popular.
     The popularity of a track is a value between 0 and 100, with 100 being the most popular. The popularity is calculated by algorithm and is based, in the most part, on the total number of plays the track has had and how recent those plays are.
     Generally speaking, songs that are being played a lot now will have a higher popularity than songs that were played a lot in the past. Duplicate tracks (e.g. the same track from a single and an album) are rated independently. Artist and album popularity is derived mathematically from track popularity. Note that the popularity value may lag actual popularity by a few days: the value is not updated in real time.
     */
    var popularity: Int { get }
}
