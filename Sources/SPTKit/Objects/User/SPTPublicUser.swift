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

/// Public User object.
public class SPTPublicUser: SPTBaseObject {
    /**
     The name displayed on the user’s profile. null if not available.
     */
    public let displayName: String?
        
    /**
     Information about the followers of this user.
     */
    public let followers: SPTFollowers?
    
    /**
     The user’s profile image.
     */
    public let images: [SPTImage]?
    
    public override var description: String {
        return "User, name: \(displayName ?? "Unknown"), id: \(id)"
    }
        
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case followers, images
        case displayName = "display_name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        followers = try container.decodeIfPresent(SPTFollowers.self, forKey: .followers)
        images = try container.decodeIfPresent([SPTImage].self, forKey: .images)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(displayName, forKey: .displayName)
        try container.encodeIfPresent(followers, forKey: .followers)
        try container.encodeIfPresent(images, forKey: .images)
        try super.encode(to: encoder)
    }
}
