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

public struct SPT {
    
    /**
     A valid access token from the Spotify Accounts service. This library does not take the responsibility of authentication. You have to implement it by yourself. [Read more](https://developer.spotify.com/documentation/general/guides/authorization-guide/)
     */
    public static var authorizationToken: String?
    
    public static var limit: Int = 20
    
    public static var shouldCacheResponses = true
    
    private static let responsesCache: URLCache = {
        if #available(iOS 13.0, *) {
            return .init(memoryCapacity: 32 * 1024 * 1024,
                         diskCapacity: 0)
        } else {
            return .shared
        }
    }()
        
    private static var session: URLSession { .shared }
    
    @available(*, unavailable)
    init() {}
    
    private static func forgeRequest(for method: SPTMethod, pathParam: String?, queryParams: [String: String]?, body: [String: Any]?) -> URLRequest? {
        
        guard let token = SPT.authorizationToken, !token.isEmpty else {
            print("*** Authorization token cannot be empty ***")
            return nil
        }
        
        guard let url = method.composed(pathParam: pathParam, queryParams: queryParams) else {
            return nil
        }
        var request = URLRequest(url: url, method: method.method, headers: [
            "Authorization": "Bearer " + token
        ])
        
        if let body = body, let data = try? JSONSerialization.data(withJSONObject: body, options: []) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        }
        return request
    }
}

// MARK: Internal methods
extension SPT {
    
    @discardableResult
    static func call<T>(method: SPTMethod, pathParam: String? = nil, queryParams: [String: String]? = nil, body: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T: Decodable {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams, body: body) else {
            completion(.failure(SPTError.badRequest))
            return nil
        }
        return perform(request: request, completion: completion)
    }
    
    @discardableResult
    static func call(method: SPTMethod, pathParam: String? = nil, queryParams: [String: String]? = nil, body: [String: Any]? = nil, completion: ((Error?) -> Void)?) -> URLSessionDataTask? {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams, body: body) else {
            completion?(SPTError.badRequest)
            return nil
        }
        return perform(request: request, completion: completion)
    }
    
    @discardableResult
    static func perform<T>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T: Decodable {
        
        func handleReceivedData(_ data: Data) {
            // Decode requested objects
            do {
                let decoded = try SPTJSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        if shouldCacheResponses,
           let cachedResponse = responsesCache.cachedResponse(for: request) {
            handleReceivedData(cachedResponse.data)
            return nil
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            // Check for any connection errors
            if let error = error {
                completion(.failure(error))
                return
            }
            // Read data
            guard let data = data, !data.isEmpty else {
                completion(.failure(SPTError.noDataReceivedError))
                return
            }
            // Check response's status code, if it's anything other than 200 (OK), try to decode SPTError from the data.
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = SPTError.badRequest
                completion(.failure(error))
                return
            }
            guard httpResponse.statusCode == 200 else {
                var sptError = (try? JSONDecoder().decode(SPTError.self, from: data)) ?? SPTError.badResponse
                sptError.additionalHeaders = httpResponse.allHeaderFields as? [String: Any]
                completion(.failure(sptError))
                return
            }
            // Cache response when there was no error and data was obtained.
            if shouldCacheResponses {
                let cachedResponse = CachedURLResponse(response: httpResponse,
                                                       data: data)
                responsesCache.storeCachedResponse(cachedResponse, for: request)
            }
            handleReceivedData(data)
        }
        defer { task.resume() }
        
        return task
    }
    
    @discardableResult
    static func perform(request: URLRequest, completion: ((Error?) -> Void)?) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            // Check any connection errors
            if let error = error {
                completion?(error)
                return
            }
            // If status code is 200 (OK), return successfully
            // If 201, "snapshot_id" was returned
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 ||
                httpResponse.statusCode == 201 {
                completion?(nil)
                return
            }
            // Read any data which will represent service error from Spotify
            guard let data = data, !data.isEmpty else {
                completion?(nil)
                return
            }
            // Decode error
            do {
                let decoded = try SPTJSONDecoder().decode(SPTError.self, from: data)
                completion?(decoded)
            } catch let decodingError {
                completion?(decodingError)
            }
        }
        defer { task.resume() }
        
        return task
    }
}

// MARK: Async/Await support.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension SPT {
    static func perform<T>(request: URLRequest) async throws -> T where T: Decodable {
        return try await withCheckedThrowingContinuation { continuation in
            perform(request: request) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    static func perform(request: URLRequest) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            perform(request: request) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}

// MARK: Async/Await support.
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension SPT {
    static func call<T>(method: SPTMethod, pathParam: String? = nil, queryParams: [String: String]? = nil, body: [String: Any]? = nil) async throws -> T where T: Decodable {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams, body: body) else {
            throw SPTError.badRequest
        }
        return try await perform(request: request)
    }
    
    static func call(method: SPTMethod, pathParam: String? = nil, queryParams: [String: String]? = nil, body: [String: Any]? = nil) async throws {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams, body: body) else {
            throw SPTError.badRequest
        }
        try await perform(request: request)
    }
}
