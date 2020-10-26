//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import Foundation
import SPTKitModels
import Alamofire

public extension SPT {
    /**
     Endpoints for retrieving information about a user’s playlists and for managing a user’s playlists.
     */
    class Playlists {
        /**
         Get a playlist owned by a Spotify user.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlist/)
         */
        public class func getPlaylist(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPlaylist, Error>) -> Void) {
            
            var queryParams = [String: String]()
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.getPlaylist, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get full details of the tracks or episodes of a playlist owned by a Spotify user.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlists-tracks/)
         */
        public class func getPlaylistTracks(id: String, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPagingObject<SPTPlaylistTrack>, Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset)
            ]
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.getPlaylistTracks, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Add one or more items to a user’s playlist.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/add-tracks-to-playlist/)
         - Parameters:
            - id: The Spotify ID for the playlist.
            - uris: Array of `Spotify URIs` to add, can be track or episode URL. Example URI: `spotify:track:0Zn0jtLj2ehkIPxlCoO65O`
            - position: The position to insert the items, a zero-based index. For example, to insert the items in the first position: position=0; to insert the items in the third position: position=2 . If omitted, the items will be appended to the playlist. Items are added in the order they are listed in the query string or request body.
            - completion: Handler called after completing the request.
         */
        public class func addTracksToPlaylist(id: String, uris: [String], position: Int?, completion: ((Error?) -> Void)?) {
            
            var queryParams = [
                "uris": uris.joined(separator: ",")
            ]
            if let position = position {
                queryParams.updateValue(String(position), forKey: "position")
            }
            let values = uris.map { uri in
                ["uri": uri]
            }
            let dict = ["tracks": values]
            
            SPT.call(method: Method.addItems, pathParam: id, queryParams: queryParams, body: dict, completion: completion)
        }
            
        private enum Method: SPTMethod {
            // Get
            case getPlaylist, getPlaylistTracks, getUserPlaylists, getPlaylistImage
            case changeDetails, replaceItems, reorderItems, replacePlaylistImage
            case addItems, createPlaylist
            case removeItems
            
            var path: String {
                switch self {
                case .createPlaylist:
                    return "users"
                case .getPlaylistTracks, .replaceItems, .reorderItems, .removeItems, .addItems, .getUserPlaylists, .getPlaylistImage, .replacePlaylistImage, .getPlaylist, .changeDetails:
                    return "playlists"
                }
            }
            
            var subpath: String? {
                switch self {
                case .getPlaylistTracks, .replaceItems, .reorderItems, .removeItems, .addItems:
                    return "tracks"
                case .createPlaylist, .getUserPlaylists:
                    return "playlists"
                case .getPlaylistImage, .replacePlaylistImage:
                    return "images"
                case .getPlaylist, .changeDetails:
                    return nil
                }
            }
            
            var method: HTTPMethod {
                switch self {
                case .changeDetails, .replaceItems, .reorderItems, .replacePlaylistImage:
                    return .put
                case .addItems, .createPlaylist:
                    return .post
                case .removeItems:
                    return .delete
                case .getPlaylist, .getPlaylistTracks, .getUserPlaylists, .getPlaylistImage:
                    return .get
                }
            }
        }
        
        private init() {}
    }
}
