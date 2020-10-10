//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import Foundation
import SPTKitModels

public extension SPT {
    class Albums {
        public class func getAlbum(id: String, completion: @escaping (Result<SPTAlbum, Error>) -> Void) {

            var queryParams = [String: String]()
            if let country = SPT.countryCode {
                queryParams["market"] = country
            }
            SPT.call(method: Method.album, pathParam: id, queryParams: queryParams, completion: completion)
        }
        
        /**
         Get Spotify catalog information about an album’s tracks. Optional parameters can be used to limit the number of tracks returned.
         */
        public class func getAlbumTracks(id: String, limit: Int = 20, offset: Int = 0, completion: @escaping (Result<SPTPagingObject<SPTSimplifiedTrack>, Error>) -> Void) {

            var queryParams = [
                "limit": String(limit),
                "offset": String(offset)
            ]
            if let country = SPT.countryCode {
                queryParams["market"] = country
            }
            
            SPT.call(method: Method.albumTracks, pathParam: id, queryParams: queryParams, completion: completion)
        }
        
        public class func getSeveralAlbums(ids: [String], completion: @escaping (Result<[SPTAlbum], Error>) -> Void) {

            var queryParams = [String: String]()
            if let country = SPT.countryCode {
                queryParams["market"] = country
            }
            queryParams["ids"] = ids.joined(separator: ",")
            
            SPT.call(method: Method.severalAlbums, pathParam: nil, queryParams: queryParams) { (result: Result<Nested<SPTAlbum>, Error>) in
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
            
            static var path: String {
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
