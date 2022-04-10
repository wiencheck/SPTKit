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

public class SPTBaseObject: Codable, GRDBRecord {
    /**
     The object type.
     */
    public let type: SPTObjectType
    
    /**
     The Spotify URI for the object.
     */
    public let uri: String
    
    /**
     The Spotify ID for the object.
     */
    public let id: String
    
    /**
     A link to the Web API endpoint providing full details of the object.
     */
    public let url: URL
    
    /**
     Known external URLs for this object.
     */
    public let externalURLs: [String: URL]
    
    /// The user information for the record.
    public var userInfo: [AnyHashable : Any]?
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case type, uri, id
        case url = "href"
        case externalURLs = "external_urls"
    }
    
    // MARK: `CustomStringConvertible` conformance
    public var description: String {
        return """
            \(type), id: \(id)
        """
    }
    
    // MARK: GRDB stuff
    public class Columns {
        public static let type = Column(CodingKeys.type)
        public static let uri = Column(CodingKeys.uri)
        public static let id = Column(CodingKeys.id)
        public static let url = Column(CodingKeys.url)
        public static let externalURLs = Column(CodingKeys.externalURLs)
        
        private init() {}
    }
    
    public class var databaseTableName: String {
        fatalError("*** Must override in subclasses.")
    }
    
    class func defineColumns(onTable table: TableDefinition) {
        
        table.column(CodingKeys.id.stringValue, .text).notNull()
            .primaryKey()
            .unique(onConflict: .replace)
        table.column(CodingKeys.type.stringValue, .text).notNull()
        table.column(CodingKeys.uri.stringValue, .text).notNull()
        table.column(CodingKeys.url.stringValue, .text).notNull()
        table.column(CodingKeys.externalURLs.stringValue, .blob).notNull()
    }
    
    public static var migration: Migration {
        
        let migrationTitle = "create\(databaseTableName.capitalized)"
        return (migrationTitle, { db in
            try db.create(table: databaseTableName, body: defineColumns)
        })
    }
    
    public static func databaseJSONDecoder(for column: String) -> JSONDecoder {
        SPTJSONDecoder()
    }
    
    public static func databaseJSONEncoder(for column: String) -> JSONEncoder {
        SPTJSONEncoder()
    }
}

// MARK: `Equatable` conformance
extension SPTBaseObject: Equatable {
    
    public static func == (lhs: SPTBaseObject, rhs: SPTBaseObject) -> Bool {
        lhs.id == rhs.id &&
        lhs.uri == rhs.uri &&
        lhs.type == rhs.type &&
        lhs.url == rhs.url &&
        lhs.externalURLs == rhs.externalURLs
    }
}

// MARK: `Hashable` conformance
extension SPTBaseObject: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(uri)
        hasher.combine(type)
        hasher.combine(url)
        hasher.combine(externalURLs)
    }
}

@available (swift 5.1)
extension SPTBaseObject: Identifiable {}
