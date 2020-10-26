//
//  File.swift
//  
//
//  Created by Adam Wienconek on 09/10/2020.
//

import Foundation
import Alamofire
import SPTKitModels

/**
 Container class for encapsuling objects included in search response from Spotify service.
 */
public class SPTSearchResponse: Codable {
    /**
     Simplified track objects included in the response, wrapped in paging object.
     */
    public let tracks: SPTPagingObject<SPTSimplifiedTrack>?
    
    /**
     Simplified album objects included in the response, wrapped in paging object.
     */
    public let albums: SPTPagingObject<SPTSimplifiedAlbum>?
    
    /**
     Simplified artist objects included in the response, wrapped in paging object.
     */
    public let artists: SPTPagingObject<SPTSimplifiedArtist>?
    
    /**
     Simplified playlist objects included in the response, wrapped in paging object.
     */
    public let playlists: SPTPagingObject<SPTSimplifiedPlaylist>?
    
//    public let shows: SPTPagingObject<SPTSimplifiedAlbum>?
//
//    public let episodes: SPTPagingObject<SPTSimplifiedAlbum>?
}

extension SPT {
    public class Search {
        /**
         Get Spotify Catalog information about albums, artists, playlists, tracks, shows or episodes that match a keyword string.
         */
        public class func search(query: String, types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTSearchResponse, Error>) -> Void) {
            
            var queryParams = [
                "q": query,
                "limit": String(limit),
                "offset": String(offset),
                "type": types.map {
                    $0.rawValue
                }.joined(separator: ",")
            ]
            queryParams.updateValue(market, forKey: "market")
            
            SPT.call(method: Method.search, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        public class func search(specifiedQuery: [SPTObjectType: String], types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<SPTSearchResponse, Error>) -> Void) {
            
            /*
             Field filters: By default, results are returned when a match is found in any field of the target object type. Searches can be made more specific by specifying an album, artist or track field filter. For example: The query q=album:gold%20artist:abba&type=album returns only albums with the text “gold” in the album name and the text “abba” in the artist name.
             */
            let query = specifiedQuery.map {
                $0.key.rawValue + ":" + $0.value
            }.joined(separator: " ")
            
            search(query: query, types: types, limit: limit, offset: offset, completion: completion)
        }
        
        private class func forgeRequest(queryParams: [String: String]?) -> URLRequest? {
            
            guard let token = SPT.authorizationToken, !token.isEmpty else {
                print("*** Authorization token cannot be empty ***")
                return nil
            }
            let header = HTTPHeader(name: "Authorization", value: "Bearer " + token)
            guard let url = Method.search.composed(pathParam: nil, queryParams: queryParams),
                let request = try? URLRequest(url: url, method: .get, headers: HTTPHeaders(arrayLiteral: header)) else {
                    return nil
            }
            return request
        }
        
        private enum Method: SPTMethod {
            case search
            
            var path: String {
                return "search"
            }
        }
    }
}
