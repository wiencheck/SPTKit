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
     Endpoints for retrieving information about one or more artists from the Spotify catalog.
     */
    struct Artists {
        private enum Method: SPTMethod {
            case artist, severalArtists, artistAlbums, topTracks, relatedArtists
            
            var path: String {
                return "artists"
            }
            
            var subpath: String? {
                switch self {
                case .artist, .severalArtists:
                    return nil
                case .artistAlbums:
                    return "albums"
                case .topTracks:
                    return "top-tracks"
                case .relatedArtists:
                    return "related-artists"
                }
            }
        }
    }
}

public extension SPT.Artists {
    
    /**
     Get artist.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/)
     
     - Parameters:
     - ids: Array of Spotify IDs for the artists. Maximum: 50 IDs.
     - limit: The maximum number of tracks to return.
     - offset: The index of the first track to return. Default: 0 (the first object). Use with limit to get the next set of tracks.
     - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
     - completion: Handler containing decoded objects, called after completing the request.
     */
    static func getArtist(id: String, completion: @escaping (Result<SPTArtist, Error>) -> Void) {
        SPT.call(method: Method.artist, pathParam: id, queryParams: nil, body: nil, completion: completion)
    }
    
    /**
     Get artist's albums.
     [Read more]( https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-albums/)
     
     - Parameters:
     - id: The Spotify ID for the artist.
     - groups:
     - limit: The number of album objects to return. Default: 20. Minimum: 1. Maximum: 50.
     - offset: The index of the first album to return. Default: 0 (i.e., the first album). Use with limit to get the next set of albums.
     - completion: Handler called on success or failure.
     */
    static func getArtistAlbums(id: String, groups: [AlbumGroup] = AlbumGroup.allCases, market: String? = SPT.countryCode, limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<SPTPagingObject<SPTAlbum>, Error>) -> Void) {
        if id.isEmpty {
            completion(.failure(SPTError.emptyParameter))
            return
        }
        if groups.isEmpty {
            completion(.failure(SPTError.albumGroupsEmpty))
            return
        }
        var queryParams = [
            "limit": String(limit),
            "offset": String(offset),
            "include_groups": groups.map {
                $0.rawValue
            }.joined(separator: ",")
        ]
        queryParams.updateValueIfExists(market, forKey: "country")
        
        SPT.call(method: Method.artistAlbums, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
    }
    
    /**
     Get Spotify catalog information about an artist’s top tracks by country.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-top-tracks/)
     
     - Parameters:
     - ids: Array of Spotify IDs for the artists. Maximum: 50 IDs.
     - limit: The maximum number of tracks to return.
     - offset: The index of the first track to return. Default: 0 (the first object). Use with limit to get the next set of tracks.
     - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
     - completion: Handler containing decoded objects, called after completing the request.
     */
    static func getArtistTopTracks(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<[SPTTrack], Error>) -> Void) {
        
        var queryParams: [String: String] = [:]
        queryParams.updateValueIfExists(market, forKey: "country")
        
        SPT.call(method: Method.topTracks, pathParam: id, queryParams: queryParams, body: nil) { (result: Result<Nested<SPTTrack>, Error>) in
            switch result {
            case .success(let root):
                completion(.success(root.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Get Spotify catalog information for several artists based on their Spotify IDs.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-several-artists/)
     - Parameters:
     - ids: Array of Spotify IDs for the artists. Maximum: 50 IDs.
     - completion: Handler containing decoded objects, called after completing the request.
     */
    static func getSeveralArtists(ids: [String], completion: @escaping (Result<[SPTArtist], Error>) -> Void) {
        
        if ids.count > 50 {
            print("*** Warning, maximum number of requested ids is 50, but \(ids.count) have been passed to the method.")
        }
        let queryParams = [
            "ids": ids.joined(separator: ",")
        ]
        SPT.call(method: Method.severalArtists, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<Nested<SPTArtist>, Error>) in
            switch result {
            case .success(let root):
                completion(.success(root.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Get Spotify catalog information about artists similar to a given artist. Similarity is based on analysis of the Spotify community’s listening history.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-related-artists/)
     */
    static func getArtistRelatedArtists(id: String, completion: @escaping (Result<[SPTArtist], Error>) -> Void) {
        
        SPT.call(method: Method.relatedArtists, pathParam: id, queryParams: nil, body: nil) { (result: Result<Nested<SPTArtist>, Error>) in
            switch result {
            case .success(let root):
                completion(.success(root.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// - MARK: Async/Await support.
@available(iOS 13.0, *)
@available(macOS 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
public extension SPT.Artists {
    /**
     Get artist.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/)
     
     - Parameters:
     - ids: Array of Spotify IDs for the artists. Maximum: 50 IDs.
     - limit: The maximum number of tracks to return.
     - offset: The index of the first track to return. Default: 0 (the first object). Use with limit to get the next set of tracks.
     - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
     - completion: Handler containing decoded objects, called after completing the request.
     */
    static func getArtist(id: String) async throws -> SPTArtist {
        return try await withCheckedThrowingContinuation { continuation in
            self.getArtist(id: id) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /**
     Get artist's albums.
     [Read more]( https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-albums/)
     
     - Parameters:
     - id: The Spotify ID for the artist.
     - groups:
     - limit: The number of album objects to return. Default: 20. Minimum: 1. Maximum: 50.
     - offset: The index of the first album to return. Default: 0 (i.e., the first album). Use with limit to get the next set of albums.
     - completion: Handler called on success or failure.
     */
    static func getArtistAlbums(id: String, groups: [AlbumGroup] = AlbumGroup.allCases, market: String? = SPT.countryCode, limit: Int = SPT.limit, offset: Int = 0) async throws -> SPTPagingObject<SPTAlbum> {
        return try await withCheckedThrowingContinuation { continuation in
            self.getArtistAlbums(id: id, groups: groups, market: market, limit: limit, offset: offset) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /**
     Get Spotify catalog information about an artist’s top tracks by country.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-top-tracks/)
     
     - Parameters:
     - ids: Array of Spotify IDs for the artists. Maximum: 50 IDs.
     - limit: The maximum number of tracks to return.
     - offset: The index of the first track to return. Default: 0 (the first object). Use with limit to get the next set of tracks.
     - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
     - completion: Handler containing decoded objects, called after completing the request.
     */
    static func getArtistTopTracks(id: String, market: String? = SPT.countryCode) async throws -> [SPTTrack] {
        return try await withCheckedThrowingContinuation { continuation in
            self.getArtistTopTracks(id: id, market: market) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /**
     Get Spotify catalog information for several artists based on their Spotify IDs.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-several-artists/)
     - Parameters:
     - ids: Array of Spotify IDs for the artists. Maximum: 50 IDs.
     - completion: Handler containing decoded objects, called after completing the request.
     */
    static func getSeveralArtists(ids: [String]) async throws -> [SPTArtist] {
        return try await withCheckedThrowingContinuation { continuation in
            self.getSeveralArtists(ids: ids) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /**
     Get Spotify catalog information about artists similar to a given artist. Similarity is based on analysis of the Spotify community’s listening history.
     [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-related-artists/)
     */
    static func getArtistRelatedArtists(id: String) async throws -> [SPTArtist] {
        return try await withCheckedThrowingContinuation { continuation in
            self.getArtistRelatedArtists(id: id) { result in
                continuation.resume(with: result)
            }
        }
    }
    
}
