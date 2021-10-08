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
import GRDB

/// Full Artist object.
public class SPTArtist: SPTBaseObject, SPTArtistProtocol {
    
    public let name: String

    public let followers: SPTFollowers?
    
    public let genres: [String]?

    public let images: [SPTImage]?
    
    public let popularity: Int?
    
    public override var description: String {
        return """
           Artist: \"\(name)\", uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case name, followers, genres, images, popularity
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        followers = try container.decodeIfPresent(SPTFollowers.self, forKey: .followers)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        images = try container.decodeIfPresent([SPTImage].self, forKey: .images)
        popularity = try container.decodeIfPresent(Int.self, forKey: .popularity)
        
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        
        try container.encodeIfPresent(followers, forKey: .followers)
        try container.encodeIfPresent(genres, forKey: .genres)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        
        try super.encode(to: encoder)
    }
    
    public override class var databaseTableName: String { "artist" }
}

/*
 Sample response
 
 {
   "external_urls" : {
     "spotify" : "https://open.spotify.com/artist/0OdUWJ0sBjDrqHygGUXeCF"
   },
   "followers" : {
     "href" : null,
     "total" : 306565
   },
   "genres" : [ "indie folk", "indie pop" ],
   "href" : "https://api.spotify.com/v1/artists/0OdUWJ0sBjDrqHygGUXeCF",
   "id" : "0OdUWJ0sBjDrqHygGUXeCF",
   "images" : [ {
     "height" : 816,
     "url" : "https://i.scdn.co/image/eb266625dab075341e8c4378a177a27370f91903",
     "width" : 1000
   }, {
     "height" : 522,
     "url" : "https://i.scdn.co/image/2f91c3cace3c5a6a48f3d0e2fd21364d4911b332",
     "width" : 640
   }, {
     "height" : 163,
     "url" : "https://i.scdn.co/image/2efc93d7ee88435116093274980f04ebceb7b527",
     "width" : 200
   }, {
     "height" : 52,
     "url" : "https://i.scdn.co/image/4f25297750dfa4051195c36809a9049f6b841a23",
     "width" : 64
   } ],
   "name" : "Band of Horses",
   "popularity" : 59,
   "type" : "artist",
   "uri" : "spotify:artist:0OdUWJ0sBjDrqHygGUXeCF"
 }
 
 */
