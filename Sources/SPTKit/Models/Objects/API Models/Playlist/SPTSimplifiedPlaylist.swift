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

/// Simplified Playlist object.
public class SPTSimplifiedPlaylist: SPTBaseObject {
    /**
     true if the owner allows other users to modify the playlist.
     */
    public let isCollaborative: Bool
    
    /**
     The playlist description. Only returned for modified, verified playlists, otherwise null .
     */
    public let descriptionText: String?
    
    /**
     Images for the playlist. The array may be empty or contain up to three images. The images are returned by size in descending order. See Working with Playlists.
     Note: If returned, the source URL for the image ( url ) is temporary and will expire in less than a day.
     */
    public let images: [SPTImage]
    
    /**
     The name of the playlist.
     */
    public let name: String
    
    /**
     The user who owns the playlist
     */
    public let owner: SPTPublicUser
    
    /**
     The playlist’s public/private status: true the playlist is public, false the playlist is private, null the playlist status is not relevant. For more about public/private status, see [Working with Playlists](https://developer.spotify.com/documentation/general/guides/working-with-playlists/).
     */
    public let isPublic: Bool?
    
    /**
     The version identifier for the current playlist. Can be supplied in other requests to target a specific playlist version.
     */
    public let snapshotId: String
    
    /**
     Number of tracks in the playlist.
     */
    public let total: Int
    
    public override var description: String {
        return """
           Playlist: \"\(name)\", total: \(total), uri: \(uri)
        """
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case images, name, owner, tracks
        case isCollaborative = "collaborative"
        case descriptionText = "description"
        case snapshotId = "snapshot_id"
        case isPublic = "public"
    }
    
    private enum TracksCodingKeys: String, CodingKey {
        case total
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        images = try container.decode([SPTImage].self, forKey: .images)
        name = try container.decode(String.self, forKey: .name)
        owner = try container.decode(SPTPublicUser.self, forKey: .owner)
        isCollaborative = try container.decode(Bool.self, forKey: .isCollaborative)
        descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        snapshotId = try container.decode(String.self, forKey: .snapshotId)
        isPublic = try container.decodeIfPresent(Bool.self, forKey: .isPublic)
        
        let subcontainer = try container.nestedContainer(keyedBy: TracksCodingKeys.self, forKey: .tracks)
        total = try subcontainer.decode(Int.self, forKey: .total)
        
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(images, forKey: .images)
        try container.encode(name, forKey: .name)
        try container.encode(owner, forKey: .owner)
        try container.encode(isCollaborative, forKey: .isCollaborative)
        try container.encode(descriptionText, forKey: .descriptionText)
        try container.encode(snapshotId, forKey: .snapshotId)
        try container.encode(isPublic, forKey: .isPublic)
        
        try super.encode(to: encoder)
    }
}

extension SPTSimplifiedPlaylist: Nestable {
    public static var pluralKey: String {
        return "playlists"
    }
}
