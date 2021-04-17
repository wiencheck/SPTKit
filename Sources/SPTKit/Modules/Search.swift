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
import SPTKitModels

extension SPT {
    public enum Search {
        /**
         Get Spotify Catalog information about albums, artists, playlists, tracks, shows or episodes that match a keyword string.
         Query must not be empty.
         */
        public static func search(query: String, types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTSearchResponse, Error>) -> Void) {
            if query.isEmpty {
                return
            }
            
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
        
        public static func search(specifiedQuery: [SPTObjectType: String], types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<SPTSearchResponse, Error>) -> Void) {
            
            /*
             Field filters: By default, results are returned when a match is found in any field of the target object type. Searches can be made more specific by specifying an album, artist or track field filter. For example: The query q=album:gold%20artist:abba&type=album returns only albums with the text “gold” in the album name and the text “abba” in the artist name.
             */
            let query = specifiedQuery.map {
                $0.key.rawValue + ":" + $0.value
            }.joined(separator: " ")
            
            search(query: query, types: types, limit: limit, offset: offset, completion: completion)
        }
        
        private enum Method: SPTMethod {
            case search
            
            var path: String {
                return "search"
            }
        }
    }
}
