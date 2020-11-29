// Copyright (c) 2020 Adam Wienconek <adwienc@icloud.com>
//
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
import Alamofire

protocol SPTMethod {
    var path: String { get }
    var subpath: String? { get }
    var method: HTTPMethod { get }
}

extension SPTMethod {
    static var root: String {
        return "api.spotify.com"
    }
    
    static var rootExtension: String {
        return "/v1/"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var subpath: String? {
        return nil
    }
}

extension SPTMethod {
    func composed(pathParam: String?, queryParams: [String: String]?) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Self.root
        components.path = Self.rootExtension + path
        if let pathParam = pathParam {
            components.path += "/" + pathParam
        }
        if let subpath = subpath {
            components.path += "/" + subpath
        }
        
        components.queryItems = queryParams?.compactMap { key, value in
            return URLQueryItem(name: key, value: value)
        }
        return components.url
    }
}
