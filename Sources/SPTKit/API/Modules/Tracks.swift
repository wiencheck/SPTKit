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
    /**
     Endpoints for retrieving information about one or more tracks from the Spotify catalog.
     */
    struct Tracks {
        private enum Method: SPTMethod {
            case track, severalTracks
            
            var path: String {
                return "tracks"
            }
        }
        
        private init() {}
    }
}

public extension SPT.Tracks {
    /**
     Get Spotify catalog information for a single track identified by its unique Spotify ID.
     */
    static func getTrack(id: String, market: String? = SPT.countryCode, completion: @escaping (Result<SPTTrack, Error>) -> Void) {
        
        var queryParams = [String: String]()
        queryParams.updateValueIfExists(market, forKey: "market")
        
        SPT.call(method: Method.severalTracks, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
    }
    
    /**
     Get Spotify catalog information for multiple tracks based on their Spotify IDs.
     */
    static func getSeveralTracks(ids: [String], market: String? = SPT.countryCode, completion: @escaping (Result<[SPTTrack], Error>) -> Void) {
        
        var queryParams = [
            "ids": ids.joined(separator: ",")
        ]
        queryParams.updateValueIfExists(market, forKey: "market")
        
        SPT.call(method: Method.severalTracks, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<Nested<SPTTrack>, Error>) in
            switch result {
            case .success(let root):
                completion(.success(root.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension SPT.Tracks {
    /**
     Get Spotify catalog information for a single track identified by its unique Spotify ID.
     */
    static func getTrack(id: String, market: String? = SPT.countryCode) async throws -> SPTTrack {
        
        var queryParams = [String: String]()
        queryParams.updateValueIfExists(market, forKey: "market")
        
        return try await SPT.call(method: Method.severalTracks, pathParam: id, queryParams: queryParams, body: nil)
    }
    
    /**
     Get Spotify catalog information for multiple tracks based on their Spotify IDs.
     */
    static func getSeveralTracks(ids: [String], market: String? = SPT.countryCode) async throws -> [SPTTrack] {
        
        var queryParams = [
            "ids": ids.joined(separator: ",")
        ]
        queryParams.updateValueIfExists(market, forKey: "market")
        
        let nested: Nested<SPTTrack> = try await SPT.call(method: Method.severalTracks, pathParam: nil, queryParams: queryParams, body: nil)
        return nested.items
    }
}
