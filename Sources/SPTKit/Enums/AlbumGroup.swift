//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public enum AlbumGroup: String, CaseIterable, Codable {
    case album, single, compilation
    case appearsOn = "appears_on"
}
