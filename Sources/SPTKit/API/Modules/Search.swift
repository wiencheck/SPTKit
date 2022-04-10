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

public extension SPT {
    struct Search {
        private enum Method: SPTMethod {
            case search
            
            var path: String {
                return "search"
            }
        }
    }
}

public extension SPT.Search {
    /**
     Get Spotify Catalog information about albums, artists, playlists, tracks, shows or episodes that match a keyword string.
     Query must not be empty.
     */
    @discardableResult
    static func search(query: String, types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<SPTSearchResponse, Error>) -> Void) -> URLSessionDataTask? {
        if query.isEmpty {
            return nil
        }
        
        let queryParams = [
            "q": query,
            "limit": String(limit),
            "offset": String(offset),
            "type": types.map {
                $0.rawValue
            }.joined(separator: ",")
        ]
        return SPT.call(method: Method.search, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
    }
    
    @discardableResult
    static func search(specifiedQuery: [SPTObjectType: String], types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0, completion: @escaping (Result<SPTSearchResponse, Error>) -> Void) -> URLSessionDataTask? {
        
        /*
         Field filters: By default, results are returned when a match is found in any field of the target object type. Searches can be made more specific by specifying an album, artist or track field filter. For example: The query q=album:gold%20artist:abba&type=album returns only albums with the text “gold” in the album name and the text “abba” in the artist name.
         */
        let query = specifiedQuery.map {
            $0.key.rawValue + ":" + $0.value
        }.joined(separator: " ")
        
        return search(query: query, types: types, limit: limit, offset: offset, completion: completion)
    }
}

// MARK: Async/Await support.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension SPT.Search {
    /**
     Get Spotify Catalog information about albums, artists, playlists, tracks, shows or episodes that match a keyword string.
     Query must not be empty.
     */
    static func search(query: String, types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0) async throws -> SPTSearchResponse {
        
        if query.isEmpty {
            throw SPTError.emptyParameter
        }
        
        let queryParams = [
            "q": query,
            "limit": String(limit),
            "offset": String(offset),
            "type": types.map {
                $0.rawValue
            }.joined(separator: ",")
        ]
        return try await SPT.call(method: Method.search, pathParam: nil, queryParams: queryParams, body: nil)
    }
    
    static func search(specifiedQuery: [SPTObjectType: String], types: [SPTObjectType] = SPTObjectType.searchTypes, limit: Int = SPT.limit, offset: Int = 0) async throws -> SPTSearchResponse {
        
        /*
         Field filters: By default, results are returned when a match is found in any field of the target object type. Searches can be made more specific by specifying an album, artist or track field filter. For example: The query q=album:gold%20artist:abba&type=album returns only albums with the text “gold” in the album name and the text “abba” in the artist name.
         */
        let query = specifiedQuery.map {
            $0.key.rawValue + ":" + $0.value
        }.joined(separator: " ")
        
        return try await search(query: query, types: types, limit: limit, offset: offset)
    }
}
