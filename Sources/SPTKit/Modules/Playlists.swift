//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import Foundation
import SPTKitModels

public extension SPT {
    class Playlists {
        /**
         Get a playlist owned by a Spotify user.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlist/)
         */
        public class func getPlaylist(id: String, completion: @escaping (Result<SPTPlaylist, Error>) -> Void) {
            
            SPT.call(method: Method.getPlaylist, pathParam: id, queryParams: nil, completion: completion)
        }
        
        private init() {}
        
        private enum Method: SPTMethod {
            case getPlaylist
            
            static var path: String {
                return "playlists"
            }
        }
    }
}
