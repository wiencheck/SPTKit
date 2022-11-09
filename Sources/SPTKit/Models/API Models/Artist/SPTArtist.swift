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

/// Full Artist object.
public struct SPTArtist: SPTItem {
    
    // MARK: Base properties
    
    public let type: SPTObjectType
    public let uri: String
    public let id: String
    public let url: URL
    public let externalURLs: [String: URL]
    
    /**
     The name of this artist.
     */
    public let name: String
    
    /**
     Information about the followers of the artist.
     */
    public let followers: SPTFollowers?
    
    /**
     A list of the genres the artist is associated with. For example: "Prog Rock" , "Post-Grunge". (If not yet classified, the array is empty.)
     */
    public let genres: [String]
    
    /**
     Images of the artist in various sizes, widest first.
     */
    public let images: [SPTImage]
    
    /**
     The popularity of the artist. The value will be between 0 and 100, with 100 being the most popular. The artist’s popularity is calculated from the popularity of all the artist’s tracks.
     */
    public let popularity: Int?
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case type, uri, id
        case url = "href"
        case externalURLs = "external_urls"
        
        case name, followers, genres, images, popularity
    }
    
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        type = try container.decode(SPTObjectType.self, forKey: .type)
//        uri = try container.decode(String.self, forKey: .uri)
//        id = try container.decode(String.self, forKey: .id)
//        url = try container.decode(URL.self, forKey: .url)
//        externalURLs = try container.decode([String: URL].self, forKey: .externalURLs)
//        
//        name = try container.decode(String.self, forKey: .name)
//        followers = try container.decodeIfPresent(SPTFollowers.self, forKey: .followers)
//        genres = try container.decode([String].self, forKey: .genres)
//        images = try container.decode([SPTImage].self, forKey: .images)
//        popularity = try container.decodeIfPresent(Int.self, forKey: .popularity)
//        
//        try super.init(from: decoder)
//    }

//    public override func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode(name, forKey: .name)
//        try container.encodeIfPresent(followers, forKey: .followers)
//        try container.encode(genres, forKey: .genres)
//        try container.encode(images, forKey: .images)
//        try container.encodeIfPresent(popularity, forKey: .popularity)
//        
//        try super.encode(to: encoder)
//    }
    
//    // MARK: GRDB
//
//    public class Columns: SPTBaseObject.Columns {
//        public static let name = Column(CodingKeys.name)
//    }
//
//    public override class var databaseTableName: String { "artist" }
//
//    public override class func defineColumns(onTable table: TableDefinition) {
//        super.defineColumns(onTable: table)
//
//        table.column(CodingKeys.name.stringValue, .text).notNull()
//    }
}

extension SPTArtist: Nestable {
    
    public static var pluralKey: String { "artists" }
    
}

@available(swift 5.1)
extension SPTArtist: Identifiable {
    
    public typealias ID = String
    
}
