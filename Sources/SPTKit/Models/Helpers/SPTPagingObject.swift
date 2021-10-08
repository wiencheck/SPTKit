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

public class SPTPagingObject<T: Codable>: Codable {
    /**
     The requested data.
     */
    public let items: [T]
    
    /**
     The maximum number of items in the response (as set in the query or by default).
     */
    public let limit: Int
    
    /**
     URL to the next page of items.
     */
    public let next: URL?
    
    public let offset: Int
    
    public let previous: URL?
    
    public let total: Int
    
    public var canMakeNextRequest: Bool {
        return next != nil
    }
    
    public var canMakePreviousRequest: Bool {
        return previous != nil
    }
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case items, limit, next, offset, previous, total
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let throwables = try container.decode([Throwable<T>].self, forKey: .items)
        items = throwables.compactMap {
            try? $0.result.get()
        }
        limit = try container.decode(Int.self, forKey: .limit)
        next = try container.decodeIfPresent(URL.self, forKey: .next)
        offset = try container.decode(Int.self, forKey: .offset)
        previous = try container.decodeIfPresent(URL.self, forKey: .previous)
        total = try container.decode(Int.self, forKey: .total)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(items, forKey: .items)
        try container.encode(limit, forKey: .limit)
        try container.encode(next, forKey: .next)
        try container.encode(offset, forKey: .offset)
        try container.encode(previous, forKey: .previous)
        try container.encode(total, forKey: .total)
    }
}

extension SPTPagingObject: CustomStringConvertible {
    public var description: String {
        return """
            Offset: \(offset), total: \(total)
            Previous: \(previous?.absoluteString ?? "nil"), Next: \(next?.absoluteString ?? "nil")
            \(items)
        """
    }
}
