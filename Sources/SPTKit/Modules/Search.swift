// Copyright (c) 2020 Adam Wienconek <adwienc@icloud.com>
//
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
import SPTKitModels

public extension SPT {
    final class Search {
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
            
            SPT.shared.call(method: Method.search, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
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
        
//        private class func forgeRequest(queryParams: [String: String]?) -> URLRequest? {
//            
//            guard let token = SPT.authorizationToken, !token.isEmpty else {
//                print("*** Authorization token cannot be empty ***")
//                return nil
//            }
//            let header = HTTPHeader(name: "Authorization", value: "Bearer " + token)
//            guard let url = Method.search.composed(pathParam: nil, queryParams: queryParams),
//                let request = try? URLRequest(url: url, method: .get, headers: HTTPHeaders(arrayLiteral: header)) else {
//                    return nil
//            }
//            return request
//        }
        
        private enum Method: SPTMethod {
            case search
            
            var path: String {
                return "search"
            }
        }
    }
}
