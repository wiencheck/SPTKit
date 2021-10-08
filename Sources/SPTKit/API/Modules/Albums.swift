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

extension SPT {
    /**
     Endpoints for retrieving information about one or more albums from the Spotify catalog.
     */
    public class Albums {
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
            queryParams.updateValueIfExists(market, forKey: "market")
            
            SPT.call(method: Method.album, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get Spotify catalog information about an album’s tracks. Optional parameters can be used to limit the number of tracks returned.
         [Read more](https://developer.spotify.com/documentation/web-api/reference/albums/get-albums-tracks/)
         
         - Parameters:
            - id: Spotify ID for the album.
            - limit: The maximum number of tracks to return.
            - offset: The index of the first track to return. Default: 0 (the first object). Use with limit to get the next set of tracks.
            - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
            - completion: Handler containing decoded objects, called after completing the request.
         */
        public class func getAlbumTracks(id: String, limit: Int = SPT.limit, offset: Int = 0, market: String? = SPT.countryCode, completion: @escaping (Result<SPTPagingObject<SPTSimplifiedTrack>, Error>) -> Void) {

            var queryParams = [
                "limit": String(limit),
                "offset": String(offset)
            ]
            queryParams.updateValueIfExists(market, forKey: "market")
            
            SPT.call(method: Method.albumTracks, pathParam: id, queryParams: queryParams, body: nil, completion: completion)
        }
        
        /**
         Get Spotify catalog information for multiple albums identified by their Spotify IDs. [Read more](https://developer.spotify.com/documentation/web-api/reference/albums/get-several-albums/)
         
         - Parameters:
            - ids: Array of Spotify IDs. Maximum: 20 IDs.
            - market: An ISO 3166-1 alpha-2 country code. Default value is read from `SPT.countryCode`.
            - completion: Handler containing decoded objects, called after completing the request.
         */
        public class func getSeveralAlbums(ids: [String], market: String? = SPT.countryCode, completion: @escaping (Result<[SPTAlbum], Error>) -> Void) {

            if ids.count > 50 {
                print("*** Warning, maximum number of requested ids is 20, but \(ids.count) have been passed to the method.")
            }
            var queryParams = [
                "ids": ids.joined(separator: ",")
            ]
            queryParams.updateValueIfExists(market, forKey: "market")
            
            SPT.call(method: Method.severalAlbums, pathParam: nil, queryParams: queryParams, body: nil) { (result: Result<Nested<SPTAlbum>, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
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
        
        private init() {}
    }
}
