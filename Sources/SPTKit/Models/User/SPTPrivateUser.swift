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

/// Private User object.
public struct SPTPrivateUser: SPTUser {
    
    // MARK: Base properties
    
    public let type: SPTObjectType
    public let uri: String
    public let id: String
    public let url: URL
    public let externalURLs: [String: URL]
    
    // MARK: User properties
    
    /**
     The name displayed on the user’s profile. null if not available.
     */
    public let displayName: String?
        
    /**
     Information about the followers of this user.
     */
    public let followers: SPTFollowers?
    
    /**
     The user’s profile image.
     */
    public let images: [SPTImage]?
    
    /**
     The country of the user, as set in the user’s account profile. An ISO 3166-1 alpha-2 country code. This field is only available when the current user has granted access to the user-read-private scope.
     */
    public let country: String?
    
    /**
     The user’s email address, as entered by the user when creating their account. Important! This email address is unverified; there is no proof that it actually belongs to the user. This field is only available when the current user has granted access to the user-read-email scope.
     */
    public let email: String?

    /**
     The user’s Spotify subscription level: “premium”, “free”, etc. (The subscription level “open” can be considered the same as “free”.) This field is only available when the current user has granted access to the user-read-private scope.
     */
    public let product: String?

    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case type, uri, id
        case url = "href"
        case externalURLs = "external_urls"
        
        case followers, images
        case displayName = "display_name"
        case country, email, product
    }
    
}
