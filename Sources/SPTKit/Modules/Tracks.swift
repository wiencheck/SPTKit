//
//  File.swift
//  
//
//  Created by Adam Wienconek on 10/10/2020.
//

import Foundation
import Alamofire
import SPTKitModels

extension SPT {
    public class Tracks {
        /**
         Get Spotify catalog information for a single track identified by its unique Spotify ID.
         */
        public class func getTrack(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<SPTTrack, Error>) -> Void) {
            
            var queryParams = [String: String]()
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.severalTracks, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        /**
         Get Spotify catalog information for multiple tracks based on their Spotify IDs.
         */
        public class func getSeveralTracks(ids: [String], market: String? = SPT.countryCode, completion: @escaping (Result<[SPTTrack], Error>) -> Void) {
            
            var queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.severalTracks, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<Nested<SPTTrack>, Error>) in
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
            case track, severalTracks
            
            var path: String {
                return "tracks"
            }
        }
    }
}
