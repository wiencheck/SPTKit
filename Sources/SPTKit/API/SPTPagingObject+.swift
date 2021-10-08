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

extension SPTPagingObject {
    public func getPrevious(completion: @escaping (Result<SPTPagingObject<T>, Error>) -> Void) {
        getPage(url: previous, completion: completion)
    }
    
    public func getNext(completion: @escaping (Result<SPTPagingObject<T>, Error>) -> Void) {
        getPage(url: next, completion: completion)
    }
    
    private func getPage(url: URL?, completion: @escaping (Result<SPTPagingObject<T>, Error>) -> Void) {
        
        guard let url = url,
            let request = forgeRequest(url: url, method: .get) else {
                completion(.failure(SPTError.badRequest))
                return
        }
        SPT.perform(request: request, completion: completion)
    }
    
    private func forgeRequest(url: URL, method: HTTPMethod) -> URLRequest? {
        guard let token = SPT.authorizationToken, !token.isEmpty else {
            print("*** Authorization token cannot be empty ***")
            return nil
        }
        return URLRequest(url: url, method: method, headers: [
            "Authorization": "Bearer " + token
        ])
    }
}
