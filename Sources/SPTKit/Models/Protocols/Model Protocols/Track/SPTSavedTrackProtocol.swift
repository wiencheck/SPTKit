//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTSavedTrackProtocol: Decodable {
    /**
     The date and time the track was saved.
     */
    var addedDate: Date { get }
    
    /**
     Information about the track.
     */
    var track: SPTTrack { get }
}
