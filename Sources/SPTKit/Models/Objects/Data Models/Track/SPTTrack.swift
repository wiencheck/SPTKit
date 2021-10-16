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
public class SPTTrack: SPTBaseObject {
    /**
     The name of this track.
     */
    public let name: String
    
    /**
     The artists who performed the track.
     */
    public let artists: [SPTArtist]
    
    /**
     A list of the countries in which the track can be played, identified by their ISO 3166-1 alpha-2 code.
     */
    public let availableMarkets: [String]
    
    /**
     The disc number (usually 1 unless the album consists of more than one disc).
     */
    public let discNumber: Int
    
    /**
     The track length in milliseconds.
     */
    public let durationMs: Int
    
    /**
     Whether or not the track has explicit lyrics ( true = yes it does; false = no it does not OR unknown).
     */
    public let isExplicit: Bool
    
    /**
     Part of the response when Track Relinking is applied. If true, the track is playable in the given market. Otherwise false.
     */
    public let isPlayable: Bool
    
    /**
     Part of the response when Track Relinking is applied, and the requested track has been replaced with different track. The track in the linked_from object contains information about the originally requested track.
     */
    public let linkedFrom: SPTLinkedTrack?
    
    /**
     A link to a 30 second preview (MP3 format) of the track. Can be null
    */
    public let previewURL: URL?
    
    /**
     The number of the track. If an album has several discs, the track number is the number on the specified disc.
     */
    public let trackNumber: Int
    
    /**
     Whether or not the track is from a local file.
     */
    public let isLocal: Bool
    
    /**
     The album on which the track appears
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let album: SPTAlbum?
    
    /**
     The popularity of the track. The value will be between 0 and 100, with 100 being the most popular.
     The popularity of a track is a value between 0 and 100, with 100 being the most popular. The popularity is calculated by algorithm and is based, in the most part, on the total number of plays the track has had and how recent those plays are.
     Generally speaking, songs that are being played a lot now will have a higher popularity than songs that were played a lot in the past. Duplicate tracks (e.g. the same track from a single and an album) are rated independently. Artist and album popularity is derived mathematically from track popularity. Note that the popularity value may lag actual popularity by a few days: the value is not updated in real time.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let popularity: Int?
    
    public override var description: String {
        return """
           Track: \"\(name)\", artists: \(artists), uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case name, artists, popularity, album, isSaved, origin
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

extension SPTTrack: Nestable {
    static var pluralKey: String {
        return "tracks"
    }
}
