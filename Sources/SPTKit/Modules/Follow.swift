//
//  File.swift
//  
//
//  Created by Adam Wienconek on 24/10/2020.
//

import SPTKitModels
import Alamofire

extension SPT {
    public class Follow {
        /**
         Add the current user as a follower of one or more artists.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public class func followArtists(ids: [String], completion: ((Error?) -> Void)?) {
            
            let queryParams = [
                "type": "artist",
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.followArtists, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Add the current user as a follower of one or more users.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public class func followUsers(ids: [String], completion: ((Error?) -> Void)?) {
            
            let queryParams = [
                "type": "user",
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.followArtists, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Add the current user as a follower of a playlist.
         - Parameters:
            - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
            - completion: Handler called after completing the request.
         */
        public class func followPlaylist(id: String, completion: ((Error?) -> Void)?) {
            
            SPT.call(method: Method.followPlaylist, pathParam: id, queryParams: nil, body: nil, completion: completion)
        }
        
        private enum Method: SPTMethod {
            // Read methods
            case isFollowingArtist, isFollowingPlaylist, followedArtists
            
            // Modify methods
            case followArtists, followPlaylist, unfollowArtists, unfollowPlaylists
            
            var path: String {
                switch self {
                case .unfollowPlaylists, .followPlaylist, .isFollowingPlaylist:
                    return "playlists"
                default:
                    return "me"
                }
            }
            
            var method: HTTPMethod {
                switch self {
                case .isFollowingArtist, .isFollowingPlaylist, .followedArtists:
                    return .get
                case .followArtists, .followPlaylist:
                    return .put
                case .unfollowArtists, .unfollowPlaylists:
                    return .delete
                }
            }
        }
        
        private init() {}
    }
}
