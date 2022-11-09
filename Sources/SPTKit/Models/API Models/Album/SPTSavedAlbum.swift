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

/// Saved Album object containing reference to the full Album object.
public struct SPTSavedAlbum: Codable, Hashable {
    
    /**
     The date and time the album was saved.
     */
    public let addedDate: Date
    
    /**
     Information about the album.
     */
    public let album: SPTAlbum
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case addedDate = "added_at"
        case album
    }
    
}

extension SPTSavedAlbum: CustomStringConvertible {
    
    public var description: String { "\(album)\naddedDate: \(addedDate)"}
    
}
