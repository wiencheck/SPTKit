//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/09/2020.
//

import SPTKitModels

public extension SPT {
    class Albums {
        public class func getAlbum(id: String, limit: Int? = nil, offset: Int? = nil, market: String? = nil, completion: @escaping (Result<SPTAlbum, Error>) -> Void) {

            var queryParams = [String: String]()
            if let limit = limit {
                queryParams["limit"] = String(limit)
            }
            if let offset = offset {
                queryParams["offset"] = String(offset)
            }
            if let market = market {
                queryParams["market"] = market
            }
            SPT.call(method: Method.album, pathParam: id, queryParams: queryParams, completion: completion)
        }
        
        public class func getSeveralAlbums(ids: [String], completion: @escaping (Result<[SPTAlbum], Error>) -> Void) {

            let queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            SPT.call(method: Method.severalAlbums, pathParam: nil, queryParams: queryParams) { (result: Result<PlurableRoot<SPTAlbum>, Error>) in
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
