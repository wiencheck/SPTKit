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
import SPTKitModels

public class SPT {
    /**
     A valid access token from the Spotify Accounts service. This library does not take the responsibility of authentication. You have to implement it by yourself. [Read more](https://developer.spotify.com/documentation/general/guides/authorization-guide/)
     */
    public static var authorizationToken: String?
    
    public static var limit: Int = 20
    
    /**
     An ISO 3166-1 alpha-2 country code.
     Supply this parameter to limit the response to one particular geographical market. For example, for albums available in Sweden: country=SE.
     If not given, results will be returned for all countries and you are likely to get duplicate results per album, one for each country in which the album is available!
     Default value is current `Locale`'s region code.
     */
    public static var countryCode: String? = Locale.current.regionCode
    
    private init() {}
}

// MARK: Internal methods
extension SPT {
    class func call<T>(method: SPTMethod, pathParam: String?, queryParams: [String: String]?, body: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams, body: body) else {
            completion(.failure(SPTError.badRequest))
            return
        }
        perform(request: request, completion: completion)
    }
    
    class func call(method: SPTMethod, pathParam: String?, queryParams: [String: String]?, body: [String: Any]?, completion: ((Error?) -> Void)?) {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams, body: body) else {
            completion?(SPTError.badRequest)
            return
        }
        perform(request: request, completion: completion)
    }
    
    // MARK: Private stuff
    private class func perform<T>(request: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {

        AF.request(request).response { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let data = response.data else {
                completion(.failure(SPTError.noDataReceivedError))
                return
            }
            if let error = try? SPTJSONDecoder().decode(SPTError.self, from: data) {
                completion(.failure(error))
            } else {
                do {
                    let object = try SPTJSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch {
                    print("error: ", error)
                }
            }
        }
    }
    
    private class func perform(request: URLRequestConvertible, completion: ((Error?) -> Void)?) {

        AF.request(request).response { response in
            if let error = response.error {
                completion?(error)
                return
            }
            guard let data = response.data,
                let error = try? SPTJSONDecoder().decode(SPTError.self, from: data) else {
                completion?(nil)
                return
            }
            completion?(error)
        }
    }
    
    private class func forgeRequest(for method: SPTMethod, pathParam: String?, queryParams: [String: String]?, body: [String: Any]?) -> URLRequest? {
        
        guard let token = SPT.authorizationToken, !token.isEmpty else {
            print("*** Authorization token cannot be empty ***")
            return nil
        }
        
        guard let url = method.composed(pathParam: pathParam, queryParams: queryParams),
            var request = try? URLRequest(url: url, method: method.method) else {
                return nil
        }
        request.headers.add(name: "Authorization", value: "Bearer " + token)
        if let body = body, let data = try? JSONSerialization.data(withJSONObject: body, options: []) {
            request.headers.add(name: "Content-Type", value: "application/json")
            request.httpBody = data
        }
        return request
    }
}
