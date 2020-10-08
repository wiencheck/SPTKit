//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import SPTKitModels

public extension SPT {
    class Artists {
        /**
         Get artist.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/)
        */
        public class func getArtist(id: String, completion: @escaping (Result<SPTArtist, Error>) -> Void) {
            
            SPT.call(method: Method.artist, pathParam: id, queryParams: nil, completion: completion)
        }
        
        public class func getSeveralArtists(ids: [String], completion: @escaping (Result<[SPTArtist], Error>) -> Void) {
            
            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.severalArtists, pathParam: nil, queryParams: queryParams) { (result: Result<PlurableRoot<SPTArtist>, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.items))
                case .failure(let error):
                    completion(.failure(error))
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
        public class func getArtistAlbums(id: String, include groups: SPTSimplifiedAlbum.AlbumGroup..., limit: Int = 20, offset: Int = 0, completion: @escaping (Result<[SPTSimplifiedAlbum], Error>) -> Void) {
            
            var queryParams = [
                "limit": String(limit),
                "offset": String(offset)
            ]
            if let country = SPT.countryCode {
                queryParams["country"] = country
            }
            queryParams["include_groups"] = groups.map {
                $0.rawValue
            }.joined(separator: ",")
            
            SPT.call(method: Method.artistAlbums, pathParam: id, queryParams: queryParams, completion: completion)
        }
        
        private init() {}
        private enum Method: SPTMethod {
            /**
            Get artist.
            [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artist/)
            */
            case artist
            
            /**
            Get several artists.
            [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-several-artists/)
            */
            case severalArtists
            
            /**
            Get artist's albums.
            [Read more]( https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-albums/)
            */
            case artistAlbums
            
            /**
            Get artist's top tracks.
            [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-artists-top-tracks/)
            */
            case topTracks
            
            /**
            Get artist's related artists.
            [Read more](https://developer.spotify.com/documentation/web-api/reference/artists/get-related-artists/)
            */
            case relatedArtists
            
            static var path: String {
                return "artists"
            }
            
            var subpath: String? {
                switch self {
                case .artist, .severalArtists:   return nil
                case .artistAlbums:     return "albums"
                case .topTracks:        return "top-tracks"
                case .relatedArtists:   return "related-artists"
                }
            }
        }
    }
}
