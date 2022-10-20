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

/// Full Album object.
public class SPTAlbum: SPTBaseObject {
    
    /**
     The name of this album.
     */
    public let name: String
    
    /**
     The field is present when getting an artist’s albums. Possible values are “album”, “single”, “compilation”, “appears_on”. Compare to album_type this field represents relationship between the artist and the album.
     */
    public let albumGroup: AlbumGroup?
    
    /**
     The type of the album: one of “album”, “single”, or “compilation”.
     */
    public let albumType: AlbumType
    
    /**
     The artists of the album. Each artist object includes a link in href to more detailed information about the artist.
     */
    public let artists: [SPTArtist]
    
    /**
     The markets in which the album is available: ISO 3166-1 alpha-2 country codes. Note that an album is considered available in a market when at least 1 of its tracks is available in that market.
     */
    public let availableMarkets: [String]
    
    /**
     The cover art for the album in various sizes, widest first.
     */
    public let images: [SPTImage]
    
    /**
     The precision with which release_date value is known: "year" , "month" , or "day".
     */
    public let releaseDatePrecision: SPTDatePrecision
    
    /**
     The date the album was first released.
     */
    public let releaseDate: Date?
    
    /**
     The copyright statements of the album.
     */
    public let copyrights: [SPTCopyright]
    
    /**
     A list of the genres used to classify the album. For example: "Prog Rock" , "Post-Grunge". (If not yet classified, the array is empty.)
     */
    public let genres: [String]
    
    /**
     The label for the album.
     */
    public let label: String?
    
    /**
     The popularity of the album. The value will be between 0 and 100, with 100 being the most popular. The popularity is calculated from the popularity of the album’s individual tracks.
     */
    public let popularity: Int?
    
    /**
     The tracks of the album.
     */
    public let tracks: SPTPagingObject<SPTTrack>?
    
    /**
     Name of main artist associated with the album.
     */
    public let albumArtistName: String
    
    /**
     Names of artists associated with the album.
     */
    public let artistNames: [String]
    
    public override var description: String {
        return """
           Album: \"\(name)\", artists: \(artists), uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case artists, images, name, copyrights, genres, label, popularity, tracks
        case albumGroup = "album_group"
        case albumType = "album_type"
        case availableMarkets = "available_markets"
        case releaseDatePrecision = "release_date_precision"
        case releaseDate = "release_date"
        
        // Additional columns
        case artistNames = "artist_names"
        case albumArtistName = "album_artist_name"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        albumGroup = try container.decodeIfPresent(AlbumGroup.self, forKey: .albumGroup)
        albumType = try container.decodeIfPresent(AlbumType.self, forKey: .albumType) ?? .album
        artists = try container.decode([SPTArtist].self, forKey: .artists)
        availableMarkets = try container.decodeIfPresent([String].self, forKey: .availableMarkets) ?? []
        images = try container.decode([SPTImage].self, forKey: .images)
        name = try container.decode(String.self, forKey: .name)
        releaseDatePrecision = try container.decode(SPTDatePrecision.self, forKey: .releaseDatePrecision)
        
        if let date = try container.decodeIfPresent(Date.self, forKey: .releaseDate) {
            releaseDate = date
        }
        else if let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = SPTDateFormatter.shared.date(from: dateString, precision: releaseDatePrecision)
        }
        else {
            releaseDate = nil
        }
        copyrights = try container.decodeIfPresent([SPTCopyright].self, forKey: .copyrights) ?? []
        genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
        label = try container.decodeIfPresent(String.self, forKey: .label)
        popularity = try container.decodeIfPresent(Int.self, forKey: .popularity)
        tracks = try container.decodeIfPresent(SPTPagingObject<SPTTrack>.self, forKey: .tracks)
        
        // Decode custom properties
        artistNames = artists.map(\.name)
        albumArtistName = artistNames.first ?? ""
        
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(albumGroup, forKey: .albumGroup)
        try container.encode(albumType, forKey: .albumType)
        try container.encode(artists, forKey: .artists)
        try container.encode(availableMarkets, forKey: .availableMarkets)
        try container.encode(images, forKey: .images)
        try container.encode(name, forKey: .name)
        try container.encode(releaseDatePrecision, forKey: .releaseDatePrecision)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(copyrights, forKey: .copyrights)
        try container.encodeIfPresent(genres, forKey: .genres)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        try container.encodeIfPresent(tracks, forKey: .tracks)
        
        // Encode custom properties
        let artistNamesString = artists
            .map(\.name)
            .joined(separator: ";")
        if !artistNamesString.isEmpty {
            try container.encode(artistNamesString, forKey: .artistNames)
        }
        try container.encode(albumArtistName, forKey: .albumArtistName)
        
        try super.encode(to: encoder)
    }
    
    // MARK: GRDB
    
    public class Columns: SPTBaseObject.Columns {
        public static let albumGroup = Column(CodingKeys.albumGroup)
        public static let albumType = Column(CodingKeys.albumType)
        public static let artists = Column(CodingKeys.artists)
        public static let availableMarkets = Column(CodingKeys.availableMarkets)
        public static let images = Column(CodingKeys.images)
        public static let name = Column(CodingKeys.name)
        public static let releaseDatePrecision = Column(CodingKeys.releaseDatePrecision)
        public static let releaseDate = Column(CodingKeys.releaseDate)
        
        public static let artistNames = Column(CodingKeys.artistNames)
        public static let albumArtistName = Column(CodingKeys.albumArtistName)
    }
    
    public override class var databaseTableName: String { "album" }
    
    public override class func defineColumns(onTable table: TableDefinition) {
        super.defineColumns(onTable: table)
        
        table.column(CodingKeys.albumGroup.stringValue, .text)
        table.column(CodingKeys.albumType.stringValue, .text).notNull()
        table.column(CodingKeys.artists.stringValue, .blob).notNull()
        table.column(CodingKeys.availableMarkets.stringValue, .blob).notNull()
        table.column(CodingKeys.images.stringValue, .blob).notNull()
        table.column(CodingKeys.name.stringValue, .text).notNull()
        table.column(CodingKeys.releaseDatePrecision.stringValue, .text).notNull()
        table.column(CodingKeys.releaseDate.stringValue, .date).notNull()
        
        table.column(CodingKeys.artistNames.stringValue, .text)
        table.column(CodingKeys.albumArtistName.stringValue, .text)
    }
    
}

extension SPTAlbum: Nestable {
    static var pluralKey: String {
        return "albums"
    }
}
