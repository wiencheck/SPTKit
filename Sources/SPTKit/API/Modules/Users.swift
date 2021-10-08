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


extension SPT {
    /**
     Endpoints for retrieving information about a user’s profile.
     */
    public class Users {
        /**
         Add the current user as a follower of a playlist.
         - Parameters:
            - completion: Handler called after completing the request.
         */
        public class func getCurrentUser(completion: @escaping (Result<SPTPrivateUser, Error>) -> Void) {
            
            SPT.call(method: Method.getCurrentUser, pathParam: nil, queryParams: nil, body: nil, completion: completion)
        }
        
        /**
         Get public profile information about a Spotify user.
         - Parameters:
            - identifier: The user’s [Spotify user ID](https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids).
            - completion: Handler called after completing the request.
         */
        public class func getUser(identifier: String, completion: @escaping (Result<SPTPublicUser, Error>) -> Void) {
            
            SPT.call(method: Method.getUser, pathParam: identifier, queryParams: nil, body: nil, completion: completion)
        }
        
        private enum Method: SPTMethod {
            // Read methods
            case getCurrentUser, getUser
            
            var path: String {
                switch self {
                case .getCurrentUser:
                    return "me"
                case .getUser:
                    return "users"
                }
            }
        }
        
        private init() {}
    }
}
