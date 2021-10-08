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

public class SPTBaseObject: SPTBaseObjectProtocol, Encodable, GRDBRecord {
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
    
    // MARK: `Equatable` conformance
    public static func == (lhs: SPTBaseObject, rhs: SPTBaseObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: `Hashable` conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uri)
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
    
    public class var databaseTableName: String { fatalError("*** Must override in subclasses.") }
    
    class var tableDefinitions: (TableDefinition) -> Void {
        { table in
            table.column(CodingKeys.id.rawValue, .text).notNull()
                .primaryKey()
                .unique(onConflict: .ignore)
            table.column(CodingKeys.type.rawValue, .text).notNull()
            table.column(CodingKeys.uri.rawValue, .text).notNull()
            table.column(CodingKeys.url.rawValue, .text).notNull()
            table.column(CodingKeys.externalURLs.rawValue, .blob).notNull()
        }
    }
    
    public class var migration: Migration {
        let migrationTitle = "create\(databaseTableName.capitalized)"
        return (migrationTitle, { db in
            try db.create(table: databaseTableName, body: tableDefinitions)
        })
    }
}

@available (swift 5.1)
extension SPTBaseObject: Identifiable {}
