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

/// Playlist track object
public struct SPTPlaylistTrack: Codable, Hashable {
    
    /**
     The date and time the track was added. Note that some very old playlists may return null in this field.
     */
    public let addedDate: Date?
    
    /**
     The Spotify user who added the track. Note that some very old playlists may return null in this field.
     */
    public let addedBy: SPTPublicUser?
    
    /**
     Whether this track is a local file or not.
     */
    public let isLocal: Bool
    
    /**
     Information about the track.
     */
    public let track: SPTTrack
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case track
        case addedDate = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
    }
}

extension SPTPlaylistTrack: CustomStringConvertible {
    public var description: String {
        return """
        PlaylistTrack: \(track.name)
        """
    }
}
