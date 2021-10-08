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

/// Full Track object.
public class SPTTrack: SPTBaseObject, SPTTrackProtocol {
    
    public let name: String

    public let artists: [SPTArtist]
    
    public let availableMarkets: [String]
    
    public let discNumber: Int
    
    public let durationMs: Int
    
    public let isExplicit: Bool
    
    public let isPlayable: Bool
    
    public let linkedFrom: SPTLinkedTrack?
    
    public let previewURL: URL?
    
    public let trackNumber: Int
    
    public let isLocal: Bool
    
    public let album: SPTAlbum?
    
    public let popularity: Int?
    
    /**
     Optional identifier of linked album.
     
     `nil` by default, should be set externally in order to estabilish association with the album.
     */
    //public var albumId: String?
    
    public override var description: String {
        return """
           Track: \"\(name)\", artists: \(artists), uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case name, artists, popularity, album, albumId, isSaved, origin
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case isExplicit = "is_explicit"
        case isPlayable = "is_playable"
        case linkedFrom = "linked_from"
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case isLocal = "is_local"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        artists = try container.decode([SPTArtist].self, forKey: .artists)
        availableMarkets = try container.decodeIfPresent([String].self, forKey: .availableMarkets) ?? []
        discNumber = try container.decode(Int.self, forKey: .discNumber)
        durationMs = try container.decode(Int.self, forKey: .durationMs)
        isExplicit = try container.decodeIfPresent(Bool.self, forKey: .isExplicit) ?? false
        isPlayable = try container.decodeIfPresent(Bool.self, forKey: .isPlayable) ?? true
        linkedFrom = try container.decodeIfPresent(SPTLinkedTrack.self, forKey: .linkedFrom)
        previewURL = try container.decodeIfPresent(URL.self, forKey: .previewURL)
        trackNumber = try container.decode(Int.self, forKey: .trackNumber)
        isLocal = try container.decode(Bool.self, forKey: .isLocal)
        album = try container.decodeIfPresent(SPTAlbum.self, forKey: .album)
        popularity = try container.decodeIfPresent(Int.self, forKey: .popularity)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(artists, forKey: .artists)
        try container.encodeIfPresent(availableMarkets, forKey: .availableMarkets)
        try container.encode(discNumber, forKey: .discNumber)
        try container.encode(durationMs, forKey: .durationMs)
        try container.encodeIfPresent(isExplicit, forKey: .isExplicit)
        try container.encode(isPlayable, forKey: .isPlayable)
        try container.encodeIfPresent(linkedFrom, forKey: .linkedFrom)
        try container.encodeIfPresent(previewURL, forKey: .previewURL)
        try container.encode(trackNumber, forKey: .trackNumber)
        try container.encode(isLocal, forKey: .isLocal)
        
        try container.encodeIfPresent(album, forKey: .album)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        
        try super.encode(to: encoder)
    }
    
    public class Columns: SPTBaseObject.Columns {
        public static let name = Column(CodingKeys.name)
        public static let artists = Column(CodingKeys.artists)
        public static let availableMarkets = Column(CodingKeys.availableMarkets)
        public static let discNumber = Column(CodingKeys.discNumber)
        public static let durationMs = Column(CodingKeys.durationMs)
        public static let isExplicit = Column(CodingKeys.isExplicit)
        public static let isPlayable = Column(CodingKeys.isPlayable)
        public static let linkedFrom = Column(CodingKeys.linkedFrom)
        public static let previewURL = Column(CodingKeys.previewURL)
        public static let trackNumber = Column(CodingKeys.trackNumber)
        public static let isLocal = Column(CodingKeys.isLocal)
        public static let album = Column(CodingKeys.album)
        public static let popularity = Column(CodingKeys.popularity)
    }
    
    public override class var databaseTableName: String { "track" }
    
    override class var tableDefinitions: (TableDefinition) -> Void {
        { table in
            super.tableDefinitions(table)
            
            table.column(CodingKeys.name.rawValue, .text).notNull()
            table.column(CodingKeys.artists.rawValue, .blob)
            table.column(CodingKeys.availableMarkets.rawValue, .blob).notNull()
            table.column(CodingKeys.discNumber.rawValue, .integer).notNull()
            table.column(CodingKeys.durationMs.rawValue, .integer).notNull()
            table.column(CodingKeys.isExplicit.rawValue, .boolean).notNull()
            table.column(CodingKeys.isPlayable.rawValue, .boolean).notNull()
            table.column(CodingKeys.linkedFrom.rawValue, .blob)
            table.column(CodingKeys.previewURL.rawValue, .text)
            table.column(CodingKeys.trackNumber.rawValue, .integer).notNull()
            table.column(CodingKeys.isLocal.rawValue, .boolean).notNull()
            
            table.column(CodingKeys.album.rawValue, .blob)
            table.column(CodingKeys.popularity.rawValue, .integer)
        }
    }
}
