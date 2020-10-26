//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import Foundation
import SPTKitModels

public extension SPT {
    /**
     Endpoints for retrieving information about one or more artists from the Spotify catalog.
     */
    class Artists {
        /**
         Get artist.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/)
        */
        public class func getArtist(id: String, completion: @escaping (Result<SPTArtist, Error>) -> Void) {
            
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
        public class func getArtistAlbums(id: String, groups: [SPTSimplifiedAlbum.AlbumGroup], market: String? = SPT.countryCode, limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<[SPTSimplifiedAlbum], Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset),
                "include_groups": groups.map {
                    $0.rawValue
                }.joined(separator: ",")
            ]
            queryParams.updateValue(market, forKey: "country")
            
            SPT.call(method: Method.artistAlbums, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get Spotify catalog information about an artist’s top tracks by country.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-top-tracks/)
         */
        public class func getArtistTopTracks(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<[SPTTrack], Error>) -> Void) {

            var queryParams = [String: String]()
            queryParams.updateValue(market, forKey: "country")
            
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
         */
        public class func getSeveralArtists(ids: [String], completion: @escaping (Result<[SPTArtist], Error>) -> Void) {
            
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
        public class func getArtistRelatedArtists(id: String, completion: @escaping (Result<[SPTArtist], Error>) -> Void) {

            SPT.call(method: Method.relatedArtists, pathParam: id, queryParams: nil, body: nil) { (result: Result<Nested<SPTArtist>, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        private init() {}
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
