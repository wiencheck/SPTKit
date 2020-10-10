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
        public class func getTrack(id: String, completion: @escaping (Result<[SPTTrack], Error>) -> Void) {
            
            var queryParams = [String: String]()
            if let country = SPT.countryCode {
                queryParams["market"] = country
            }
            
            SPT.call(method: Method.severalTracks, pathParam: id, queryParams: queryParams, completion: completion)
        }
        /**
         Get Spotify catalog information for multiple tracks based on their Spotify IDs.
         */
        public class func getSeveralTracks(ids: [String], completion: @escaping (Result<[SPTTrack], Error>) -> Void) {
            
            var queryParams = [String: String]()
            if let country = SPT.countryCode {
                queryParams["market"] = country
            }
            queryParams["ids"] = ids.joined(separator: ",")
            
            SPT.call(method: Method.severalTracks, pathParam: nil, queryParams: queryParams) { (result: Result<Nested<SPTTrack>, Error>) in
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
            case track
            case severalTracks
            
            static var path: String {
                return "tracks"
            }
            
            var subpath: String? {
                switch self {
                default: return nil
                }
            }
        }
    }
}
