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
     Endpoints for retrieving information about one or more albums from the Spotify catalog.
     */
    class Albums {
        /**
         Get Spotify catalog information for a single album.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/albums/get-album/)
         
         - Parameters:
         - limit: The maximum number of objects to return. Default value is read from `SPT.limit`.
         - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
         - completion: Handler containing decoded objects, called after completing the request.
         */
        public class func getAlbum(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<SPTAlbum, Error>) -> Void) {

            var queryParams = [String: String]()
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.album, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get Spotify catalog information about an album’s tracks. Optional parameters can be used to limit the number of tracks returned.
         */
        public class func getAlbumTracks(id: String, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPagingObject<SPTSimplifiedTrack>, Error>) -> Void) {

            var queryParams = [
                "limit": String(limit),
                "offset": String(offset)
            ]
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.albumTracks, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        public class func getSeveralAlbums(ids: [String], market: String? = SPT.countryCode, completion: @escaping (Result<[SPTAlbum], Error>) -> Void) {

            var queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.severalAlbums, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<Nested<SPTAlbum>, Error>) in
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
            case album, albumTracks, severalAlbums
            
            var path: String {
                return "albums"
            }
            
            var subpath: String? {
                switch self {
                case .albumTracks:  return "tracks"
                case .album, .severalAlbums:   return nil
                }
            }
        }
    }
}
