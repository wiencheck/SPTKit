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

public struct SPTError: Codable {
    /**
     The HTTP status code that is also returned in the response header. For further information, see https://developer.spotify.com/documentation/web-api/#response-status-codes.
     */
    public let status: Int
    
    /**
     A short description of the cause of the error.
     */
    public let message: String
    
    /**
     Additional info about the error. `AdditionalHeaders` contains some of the possible key values.
     */
    public var additionalHeaders: [String: Any]?
    
    // MARK: Codable stuff
    private enum CodingKeys: String, CodingKey {
        case error
    }
    
    private enum NestedCodingKeys: String, CodingKey {
        case status, message
    }
    
    init(status: Int, message: String) {
        self.status = status
        self.message = message
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let subcontainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .error)
        status = try subcontainer.decode(Int.self, forKey: .status)
        message = try subcontainer.decode(String.self, forKey: .message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var subcontainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .error)
        try subcontainer.encode(status, forKey: .status)
        try subcontainer.encode(status, forKey: .status)
    }
}

extension SPTError: LocalizedError {
    public var errorDescription: String? {
        return message
    }
}

public extension SPTError {
    static let emptyAuthorizationTokenError = SPTError(status: 50, message: "Authorization token was empty.")
    static let noDataReceivedError = SPTError(status: 51, message: "No data received.")
    static let decodingError = SPTError(status: 52, message: "Could not decode data.")
    static let badRequest = SPTError(status: 53, message: "Could not create valid request.")
    static let invalidCodingKey = SPTError(status: 54, message: "Couldn't create valid CodingKey")
    static let exceededRequestedIdCount = SPTError(status: 55, message: "Maximum number of requested ids was exceeded.")
    static let albumGroupsEmpty = SPTError(status: 56, message: "Album groups cannot be empty.")
    static let badResponse = SPTError(status: 57, message: "Received invalid response.")
}
