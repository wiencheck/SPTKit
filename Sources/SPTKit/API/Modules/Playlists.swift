// Copyright (c) 2020 Adam Wienconek <adwienc@icloud.com>
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public extension SPT {
    /**
     Endpoints for retrieving information about a user’s playlists and for managing a user’s playlists.
     */
    struct Playlists {
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

public extension SPT.Playlists {
    /**
     Get a playlist owned by a Spotify user.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlist/)
     */
    static func getPlaylist(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPlaylist, Error>) -> Void) {
        
        var queryParams = [String: String]()
        queryParams.updateValueIfExists(market, forKey: "market")
        
        SPT.call(method: Method.getPlaylist, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
    }
    
    /**
     Get full details of the tracks or episodes of a playlist owned by a Spotify user.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlists-tracks/)
     */
    static func getPlaylistTracks(id: String, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPagingObject<SPTPlaylistTrack>, Error>) -> Void) {
        
        var queryParams = [
            "limit": String(limit),
            "offset": String(offset)
        ]
        queryParams.updateValueIfExists(market, forKey: "market")
        
        SPT.call(method: Method.getPlaylistTracks, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
    }
    
    /**
     Add one or more items to a user’s playlist.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/add-tracks-to-playlist/)
     - Parameters:
     - id: The Spotify ID for the playlist.
     - uris: Array of `Spotify URIs` to add, can be track or episode URL. Example URI: `spotify:track:0Zn0jtLj2ehkIPxlCoO65O`
     - position: Optional. The position to insert the items, a zero-based index. For example, to insert the items in the first position: position=0; to insert the items in the third position: position=2 . If omitted, the items will be appended to the playlist. Items are added in the order they are listed in the query string or request body.
     - completion: Handler called after completing the request.
     */
    static func addTracksToPlaylist(id: String, uris: [String], position: Int?, completion: ((Error?) -> Void)?) {
        
        var queryParams = [
            "uris": uris.joined(separator: ",")
        ]
        if let position = position {
            queryParams.updateValueIfExists(String(position), forKey: "position")
        }
        let values = uris.map { uri in
            ["uri": uri]
        }
        let dict = ["tracks": values]
        
        SPT.call(method: Method.addItems, pathParam: id, queryParams: queryParams, body: dict, completion: completion)
    }
    
    /**
     Remove one or more items from a user’s playlist.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/remove-tracks-playlist/)
     - Parameters:
     - id: The Spotify ID for the playlist.
     - uris: Array of `Spotify URIs` to add, can be track or episode URL. Example URI: `spotify:track:0Zn0jtLj2ehkIPxlCoO65O`
     - position: Optional. The position to insert the items, a zero-based index. For example, to insert the items in the first position: position=0; to insert the items in the third position: position=2 . If omitted, the items will be appended to the playlist. Items are added in the order they are listed in the query string or request body.
     - completion: Handler called after completing the request.
     */
    static func removeTracksFromPlaylist(id: String, uris: [String], positions: [[Int]], completion: ((Error?) -> Void)?) {
        
        let queryParams = [
            "uris": uris.joined(separator: ",")
        ]
        let values = uris.enumerated().map { (idx: Int, uri: String) -> [String: Any] in
            var value: [String: Any] = ["uri": uri]
            if !positions.isEmpty {
                value.updateValueIfExists(positions[idx], forKey: "positions")
            }
            return value
        }
        let dict = ["tracks": values]
        
        SPT.call(method: Method.removeItems, pathParam: id, queryParams: queryParams, body: dict, completion: completion)
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension SPT.Playlists {
    /**
     Get a playlist owned by a Spotify user.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlist/)
     */
    static func getPlaylist(id: String, market: String? = SPT.countryCode) async throws -> SPTPlaylist {
        
        var queryParams = [String: String]()
        queryParams.updateValueIfExists(market, forKey: "market")
        
        return try await SPT.call(method: Method.getPlaylist, pathParam: id, queryParams: queryParams, body: nil)
    }
    
    /**
     Get full details of the tracks or episodes of a playlist owned by a Spotify user.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlists-tracks/)
     */
    static func getPlaylistTracks(id: String, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode) async throws -> SPTPagingObject<SPTPlaylistTrack> {
        
        var queryParams = [
            "limit": String(limit),
            "offset": String(offset)
        ]
        queryParams.updateValueIfExists(market, forKey: "market")
        
        return try await SPT.call(method: Method.getPlaylistTracks, pathParam: id, queryParams: queryParams, body: nil)
    }
    
    /**
     Add one or more items to a user’s playlist.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/add-tracks-to-playlist/)
     - Parameters:
     - id: The Spotify ID for the playlist.
     - uris: Array of `Spotify URIs` to add, can be track or episode URL. Example URI: `spotify:track:0Zn0jtLj2ehkIPxlCoO65O`
     - position: Optional. The position to insert the items, a zero-based index. For example, to insert the items in the first position: position=0; to insert the items in the third position: position=2 . If omitted, the items will be appended to the playlist. Items are added in the order they are listed in the query string or request body.
     - completion: Handler called after completing the request.
     */
    static func addTracksToPlaylist(id: String, uris: [String], position: Int?) async throws {
        
        var queryParams = [
            "uris": uris.joined(separator: ",")
        ]
        if let position = position {
            queryParams.updateValueIfExists(String(position), forKey: "position")
        }
        let values = uris.map { uri in
            ["uri": uri]
        }
        let dict = ["tracks": values]
        
        try await SPT.call(method: Method.addItems, pathParam: id, queryParams: queryParams, body: dict)
    }
    
    /**
     Remove one or more items from a user’s playlist.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/remove-tracks-playlist/)
     - Parameters:
     - id: The Spotify ID for the playlist.
     - uris: Array of `Spotify URIs` to add, can be track or episode URL. Example URI: `spotify:track:0Zn0jtLj2ehkIPxlCoO65O`
     - position: Optional. The position to insert the items, a zero-based index. For example, to insert the items in the first position: position=0; to insert the items in the third position: position=2 . If omitted, the items will be appended to the playlist. Items are added in the order they are listed in the query string or request body.
     - completion: Handler called after completing the request.
     */
    static func removeTracksFromPlaylist(id: String, uris: [String], positions: [[Int]]) async throws {
        
        let queryParams = [
            "uris": uris.joined(separator: ",")
        ]
        let values = uris.enumerated().map { (idx: Int, uri: String) -> [String: Any] in
            var value: [String: Any] = ["uri": uri]
            if !positions.isEmpty {
                value.updateValueIfExists(positions[idx], forKey: "positions")
            }
            return value
        }
        let dict = ["tracks": values]
        
        try await SPT.call(method: Method.removeItems, pathParam: id, queryParams: queryParams, body: dict)
    }
}
