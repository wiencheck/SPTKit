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

public extension SPTError {
    /**
     Web API uses the following response status codes, as defined in the RFC 2616 and RFC 6585.
     */
    enum ErrorCode: Int {
        /// The request could not be understood by the server due to malformed syntax. The message body will contain more information
        case badRequest = 400
        
        /// The request requires user authentication or, if the request included authorization credentials, authorization has been refused for those credentials.
        case unauthorized = 401
        
        /// The server understood the request, but is refusing to fulfill it.
        case forbidden = 403
        
        /// The requested resource could not be found. This error can be due to a temporary or permanent condition.
        case notFound = 404
        
        /// Rate limiting has been applied.
        case tooManyRequests = 429
        
        /// You should never receive this error because our clever coders catch them all … but if you are unlucky enough to get one, please report it to us through a comment at the bottom of this page.
        case internalServerError = 500
        
        /// The server was acting as a gateway or proxy and received an invalid response from the upstream server.
        case badGateway = 502
        
        /// The server is currently unable to handle the request due to a temporary condition which will be alleviated after some delay. You can choose to resend the request again.
        case serviceUnavailable = 503
    }
    
    /**
     Error code based on `status` value.
     */
    var errorCode: ErrorCode? {
        return ErrorCode(rawValue: status)
    }
}
