// Copyright (c) 2020 Adam Wienconek <adwienc@icloud.com>
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

fileprivate extension SPTPagingObject {
    func forgeRequest(url: URL, method: HTTPMethod) -> URLRequest? {
        guard let token = SPT.authorizationToken, !token.isEmpty else {
            print("*** Authorization token cannot be empty ***")
            return nil
        }
        return URLRequest(url: url, method: method, headers: [
            "Authorization": "Bearer " + token
        ])
    }
}

fileprivate extension SPTPagingObject {
    func getPage(url: URL?, completion: @escaping (Result<SPTPagingObject<T>, Error>) -> Void) {
        
        guard let url = url,
            let request = forgeRequest(url: url, method: .get) else {
                completion(.failure(SPTError.badRequest))
                return
        }
        SPT.perform(request: request, completion: completion)
    }
}

public extension SPTPagingObject {
    func getPrevious(completion: @escaping (Result<SPTPagingObject<T>, Error>) -> Void) {
        getPage(url: previous, completion: completion)
    }
    
    func getNext(completion: @escaping (Result<SPTPagingObject<T>, Error>) -> Void) {
        getPage(url: next, completion: completion)
    }
}

// - MARK: Async/Await support.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
fileprivate extension SPTPagingObject {
    func getPage(url: URL?) async throws -> SPTPagingObject<T> {
        
        guard let url = url,
            let request = forgeRequest(url: url, method: .get) else {
                throw(SPTError.badRequest)
        }
        return try await SPT.perform(request: request)
    }
}

// - MARK: Async/Await support.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
public extension SPTPagingObject {
    func getPrevious() async throws -> SPTPagingObject<T> {
        try await getPage(url: previous)
    }
    
    func getNext() async throws -> SPTPagingObject<T> {
        try await getPage(url: next)
    }
}
