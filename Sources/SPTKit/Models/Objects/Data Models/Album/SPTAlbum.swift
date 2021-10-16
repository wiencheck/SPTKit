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
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let copyrights: [SPTCopyright]?
    
    /**
     A list of the genres used to classify the album. For example: "Prog Rock" , "Post-Grunge". (If not yet classified, the array is empty.)
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let genres: [String]?
    
    /**
     The label for the album.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let label: String?
    
    /**
     The popularity of the album. The value will be between 0 and 100, with 100 being the most popular. The popularity is calculated from the popularity of the album’s individual tracks.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let popularity: Int?
    
    /**
     The tracks of the album.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    public let tracks: SPTPagingObject<SPTTrack>?
    
    public override var description: String {
        return """
           Album: \"\(name)\", artists: \(artists), uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case artists, images, name
        case albumGroup = "album_group"
        case albumType = "album_type"
        case availableMarkets = "available_markets"
        case releaseDatePrecision = "release_date_precision"
        case releaseDate = "release_date"
        
        case copyrights, genres, label, popularity, tracks
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

        /* During encoding `releaseDate` is stored as Date, as opposed to JSON response which contains this value in String. */
        if let date = try? container.decode(Date.self, forKey: .releaseDate) {
            releaseDate = date
        } else {
            let dateString = try container.decode(String.self, forKey: .releaseDate)
            releaseDate = SPTDateFormatter.shared.date(from: dateString, precision: releaseDatePrecision)
        }
        
        copyrights = try container.decodeIfPresent([SPTCopyright].self, forKey: .copyrights)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        popularity = try container.decodeIfPresent(Int.self, forKey: .popularity)
        tracks = try container.decodeIfPresent(SPTPagingObject<SPTTrack>.self, forKey: .tracks)
        
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
        try container.encode(releaseDate, forKey: .releaseDate)
        
        try container.encodeIfPresent(copyrights, forKey: .copyrights)
        try container.encodeIfPresent(genres, forKey: .genres)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        try container.encodeIfPresent(tracks, forKey: .tracks)
        
        try super.encode(to: encoder)
    }
    
    public override class var databaseTableName: String { "album" }
    
    override class var tableDefinitions: (TableDefinition) -> Void {
        { table in
            super.tableDefinitions(table)
            
            table.column(CodingKeys.albumGroup.rawValue, .text)
            table.column(CodingKeys.albumType.rawValue, .text).notNull()
            table.column(CodingKeys.artists.rawValue, .blob).notNull()
            table.column(CodingKeys.availableMarkets.rawValue, .blob).notNull()
            table.column(CodingKeys.images.rawValue, .blob).notNull()
            table.column(CodingKeys.name.rawValue, .text).notNull()
            table.column(CodingKeys.releaseDatePrecision.rawValue, .text).notNull()
            table.column(CodingKeys.releaseDate.rawValue, .date).notNull()
            
            table.column(CodingKeys.copyrights.rawValue, .blob)
            table.column(CodingKeys.genres.rawValue, .blob)
            table.column(CodingKeys.label.rawValue, .text)
            table.column(CodingKeys.popularity.rawValue, .integer)
            table.column(CodingKeys.tracks.rawValue, .blob)
        }
    }
}

extension SPTAlbum: Nestable {
    static var pluralKey: String {
        return "albums"
    }
}
