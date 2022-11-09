//
//  File.swift
//  
//
//  Created by Adam Wienconek on 09/11/2022.
//

import Foundation

public protocol SPTUser: SPTItem {
    
    /**
     The name displayed on the user’s profile. null if not available.
     */
    var displayName: String? { get }
    
    /**
     Information about the followers of this user.
     */
    var followers: SPTFollowers? { get }
    
    /**
     The user’s profile image.
     */
    var images: [SPTImage]? { get }
    
}
