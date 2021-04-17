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
import SPTKitModels

extension SPT {
    /**
     Endpoints for retrieving information about, and managing, tracks that the current user has saved in their “Your Music” library.
     */
    public enum Library {
        
        /**
         Get a list of the albums saved in the current Spotify user’s ‘Your Music’ library.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/)
         - Parameters:
            - limit: The maximum number of objects to return. Default value is read from `SPT.limit`.
            - offset: The index of the first object to return. Default: 0 (the first object). Maximum offset: 100.000. Use with limit to get the next set of playlists.
            - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
            - completion: Handler containing decoded objects, called after completing the request.
         */
        public static func getSavedAlbums(limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPagingObject<SPTSavedAlbum>, Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset),
            ]
            if let market = market {
                queryParams["market"] = market
            }
            SPT.call(method: Method.savedAlbums, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get a list of the songs saved in the current Spotify user’s ‘Your Music’ library.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-tracks/)
         - Parameters:
            - limit: The maximum number of objects to return. Default value is read from `SPT.limit`.
            - offset: The index of the first object to return. Default: 0 (the first object). Maximum offset: 100.000. Use with limit to get the next set of playlists.
            - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
            - completion: Handler containing decoded objects, called after completing the request.
         */
        public static func getSavedTracks(limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPagingObject<SPTSavedTrack>, Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset),
            ]
            if let market = market {
                queryParams["market"] = market
            }
            SPT.call(method: Method.savedTracks, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get a list of the playlists owned or followed by the current Spotify user.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/playlists/get-a-list-of-current-users-playlists/)
         - Parameters:
            - limit: The maximum number of objects to return. Default value is read from `SPT.limit`.
            - offset: The index of the first object to return. Default: 0 (the first object). Maximum offset: 100.000. Use with limit to get the next set of playlists.
            - completion: Handler containing decoded objects, called after completing the request.
         */
        public static func getFollowedPlaylists(limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<SPTPagingObject<SPTSimplifiedPlaylist>, Error>) -> Void) {
            
            let queryParams = [
                "limit": String(limit),
                "offset": String(offset),
            ]
            SPT.call(method: Method.savedPlaylists, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Save one or more tracks to the current user’s ‘Your Music’ library.
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public static func saveTracks(ids: [String], completion: ((Error?) -> Void)?) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.saveTracks, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Save one or more albums to the current user’s ‘Your Music’ library.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/library/save-albums-user/)
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public static func saveAlbums(ids: [String], completion: ((Error?) -> Void)?) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.saveAlbums, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Check if one or more albums is already saved in the current Spotify user’s ‘Your Music’ library.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-albums/)
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request. Returns dictionary object keyed by Spotify ID with boolean value indicating whether album is saved.
         */
        public static func checkSavedAlbums(ids: [String], completion: @escaping (Result<[String: Bool], Error>) -> Void) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.checkSavedAlbums, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<[Bool], Error>) in
                switch result {
                case .success(let values):
                    let dict = Dictionary(uniqueKeysWithValues: zip(ids, values))
                    completion(.success(dict))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        /**
         Check if one or more tracks is already saved in the current Spotify user’s ‘Your Music’ library.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/library/check-users-saved-tracks/)
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request. Returns dictionary object keyed by Spotify ID with boolean value indicating whether track is saved.
         */
        public static func checkSavedTracks(ids: [String], completion: @escaping (Result<[String: Bool], Error>) -> Void) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.checkSavedTracks, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<[Bool], Error>) in
                switch result {
                case .success(let values):
                    let dict = Dictionary(uniqueKeysWithValues: zip(ids, values))
                    completion(.success(dict))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        /**
         Remove one or more tracks from the current user’s ‘Your Music’ library.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/library/remove-albums-user/)
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public static func removeSavedTracks(ids: [String], completion: ((Error?) -> Void)?) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.removeTracks, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Remove one or more albums from the current user’s ‘Your Music’ library.
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public static func removeSavedAlbums(ids: [String], completion: ((Error?) -> Void)?) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.removeAlbums, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        private enum Method: SPTMethod {
            // Read methods
            case savedAlbums, savedTracks, savedPlaylists, checkSavedAlbums, checkSavedTracks
            
            // Modify methods
            case saveTracks, saveAlbums, removeTracks, removeAlbums
            
            var path: String {
                return "me"
            }
            
            var subpath: String? {
                switch self {
                case .savedAlbums, .saveAlbums, .removeAlbums:
                    return "albums"
                case .checkSavedAlbums, .checkSavedTracks:
                    return "contains"
                case .savedTracks, .saveTracks, .removeTracks:
                    return "tracks"
                case .savedPlaylists:
                    return "playlists"
                }
            }
            
            var method: HTTPMethod {
                switch self {
                case .saveTracks, .saveAlbums:
                    return .put
                case .removeTracks, .removeAlbums:
                    return .delete
                case .savedAlbums, .savedTracks, .savedPlaylists, .checkSavedAlbums, .checkSavedTracks:
                    return .get
                }
            }
        }
    }
}
