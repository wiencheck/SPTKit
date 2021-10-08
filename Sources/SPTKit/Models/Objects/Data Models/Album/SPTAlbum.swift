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

/// Full Album object.
public class SPTAlbum: SPTSimplifiedAlbum, SPTAlbumProtocol {
    
    public let copyrights: [SPTCopyright]
    
    public let genres: [String]
    
    public let label: String
    
    public let popularity: Int
    
    public let tracks: SPTPagingObject<SPTSimplifiedTrack>
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case copyrights, genres, label, popularity, tracks
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        copyrights = try container.decode([SPTCopyright].self, forKey: .copyrights)
        genres = try container.decode([String].self, forKey: .genres)
        label = try container.decode(String.self, forKey: .label)
        popularity = try container.decode(Int.self, forKey: .popularity)
        tracks = try container.decode(SPTPagingObject<SPTSimplifiedTrack>.self, forKey: .tracks)
        
        try super.init(from: decoder)
    }
    
    public required init() {
        fatalError("SPTKit objects should not be created directly.")
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(copyrights, forKey: .copyrights)
        try container.encode(genres, forKey: .genres)
        try container.encode(label, forKey: .label)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(tracks, forKey: .tracks)
        
        try super.encode(to: encoder)
    }
}
