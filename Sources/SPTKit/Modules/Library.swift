//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import SPTKitModels

public extension SPT {
    class Library {
        public class func getSavedAlbums(limit: Int = 20, offset: Int = 0, market: String? = nil, completion: @escaping (Result<SPTPagingObject<SPTSavedAlbum>, Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset),
            ]
            if let market = market {
                queryParams["market"] = market
            }
            SPT.call(method: Method.savedAlbums, pathParam: nil, queryParams: queryParams, completion: completion)
        }
        
        public class func getSavedTracks(limit: Int = 20, offset: Int = 0, market: String? = nil, completion: @escaping (Result<SPTPagingObject<SPTSavedTrack>, Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset),
            ]
            if let market = market {
                queryParams["market"] = market
            }
            SPT.call(method: Method.savedAlbums, pathParam: nil, queryParams: queryParams, completion: completion)
        }
        
        private init() {}
        private enum Method: SPTMethod {
            /**
             Get a list of the albums saved in the current Spotify user’s ‘Your Music’ library.
             [Read more](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/)
             */
            case savedAlbums
            
            /**
             Get a list of the songs saved in the current Spotify user’s ‘Your Music’ library.
             [Read more](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/)
             */
            case savedTracks
            
            static var path: String {
                return "me"
            }
        }
    }
}
