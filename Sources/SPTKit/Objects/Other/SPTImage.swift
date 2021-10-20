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

public struct SPTImage: Codable {
    /**
     The image height in pixels. If unknown: 0 or not returned.
     */
    public let height: Int
    
    /**
     The image width in pixels. If unknown: 0 or not returned.
     */
    public let width: Int
    
    /**
     The source URL of the image.
     */
    public let url: URL

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        
        if let _url = try container.decodeIfPresent(URL.self, forKey: .url) {
            url = _url
        } else {
            let _url = try container.decode(String.self, forKey: .url)
            url = URL(string: _url)!
        }
    }
}
