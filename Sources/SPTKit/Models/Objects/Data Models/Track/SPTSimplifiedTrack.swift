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

/// Simplified Track object.
public class SPTSimplifiedTrack: SPTBaseObject, SPTSimplifiedTrackProtocol {
    public let name: String

    public let artists: [SPTSimplifiedArtist]
    
    public let availableMarkets: [String]
    
    public let discNumber: Int
    
    public let durationMs: Int
    
    public let isExplicit: Bool
    
    public let isPlayable: Bool
    
    public let linkedFrom: SPTLinkedTrack?
    
    public let previewUrl: URL?
    
    public let trackNumber: Int
    
    public let isLocal: Bool
    
    public override var description: String {
        return """
           Track: \"\(name)\", artists: \(artists), uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case name, artists, popularity
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case isExplicit = "is_explicit"
        case isPlayable = "is_playable"
        case linkedFrom = "linked_from"
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case isLocal = "is_local"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        artists = try container.decode([SPTSimplifiedArtist].self, forKey: .artists)
        availableMarkets = try container.decodeIfPresent([String].self, forKey: .availableMarkets) ?? []
        discNumber = try container.decode(Int.self, forKey: .discNumber)
        durationMs = try container.decode(Int.self, forKey: .durationMs)
        isExplicit = try container.decodeIfPresent(Bool.self, forKey: .isExplicit) ?? false
        isPlayable = try container.decodeIfPresent(Bool.self, forKey: .isPlayable) ?? true
        linkedFrom = try container.decodeIfPresent(SPTLinkedTrack.self, forKey: .linkedFrom)
        previewUrl = try container.decodeIfPresent(URL.self, forKey: .previewUrl)
        trackNumber = try container.decode(Int.self, forKey: .trackNumber)
        isLocal = try container.decode(Bool.self, forKey: .isLocal)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(artists, forKey: .artists)
        try container.encode(availableMarkets, forKey: .availableMarkets)
        try container.encode(discNumber, forKey: .discNumber)
        try container.encode(durationMs, forKey: .durationMs)
        try container.encode(isExplicit, forKey: .isExplicit)
        try container.encode(isPlayable, forKey: .isPlayable)
        try container.encodeIfPresent(linkedFrom, forKey: .linkedFrom)
        try container.encodeIfPresent(previewUrl, forKey: .previewUrl)
        try container.encode(trackNumber, forKey: .trackNumber)
        try container.encode(isLocal, forKey: .isLocal)
        try super.encode(to: encoder)
    }
}
