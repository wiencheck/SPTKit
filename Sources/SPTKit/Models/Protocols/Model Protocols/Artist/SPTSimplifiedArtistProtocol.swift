//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTSimplifiedArtistProtocol: SPTBaseObjectProtocol, Nestable {
    /**
     The name of this artist.
     */
    var name: String { get }
}

public extension SPTSimplifiedArtistProtocol where Self: Nestable {
    static var pluralKey: String {
        return "artists"
    }
}
