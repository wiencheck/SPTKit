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

public extension SPT {
    /**
     Endpoints for managing the artists, users, and playlists that a Spotify user follows.
     */
    struct Follow {
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

public extension SPT.Follow {
    
    /**
     Add the current user as a follower of one or more artists.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
     - Parameters:
     - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
     - completion: Handler called after completing the request.
     */
    static func followArtists(ids: [String], completion: ((Error?) -> Void)?) {
        
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
    static func followUsers(ids: [String], completion: ((Error?) -> Void)?) {
        
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
    static func followPlaylist(id: String, completion: ((Error?) -> Void)?) {
        
        SPT.call(method: Method.followPlaylist, pathParam: id, queryParams: nil, body: nil, completion: completion)
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension SPT.Follow {
    
    /**
     Add the current user as a follower of one or more artists.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
     - Parameters:
     - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
     - completion: Handler called after completing the request.
     */
    static func followArtists(ids: [String]) async throws {
        
        let queryParams = [
            "type": "artist",
            "ids": ids.joined(separator: ",")
        ]
        try await SPT.call(method: Method.followArtists, pathParam: nil, queryParams: queryParams, body: nil)
    }
    
    /**
     Add the current user as a follower of one or more users.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/follow/follow-artists-users/)
     - Parameters:
     - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
     - completion: Handler called after completing the request.
     */
    static func followUsers(ids: [String]) async throws {
        
        let queryParams = [
            "type": "user",
            "ids": ids.joined(separator: ",")
        ]
        try await SPT.call(method: Method.followArtists, pathParam: nil, queryParams: queryParams, body: nil)
    }
    
    /**
     Add the current user as a follower of a playlist.
     - Parameters:
     - ids: A comma-separated list of the Spotify IDs. Maximum: 50 IDs.
     - completion: Handler called after completing the request.
     */
    static func followPlaylist(id: String) async throws {
        
        try await SPT.call(method: Method.followPlaylist, pathParam: id, queryParams: nil, body: nil)
    }
}
