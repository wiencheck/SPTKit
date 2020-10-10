//
//  File.swift
//  
//
//  Created by Adam Wienconek on 09/10/2020.
//

import Foundation
import Alamofire
import SPTKitModels

extension SPTPagingObject {
    public func getPrevious(completion: @escaping (Result<SPTPagingObject<T>?, Error>) -> Void) {
        getPage(url: previous, completion: completion)
    }
    
    public func getNext(completion: @escaping (Result<SPTPagingObject<T>?, Error>) -> Void) {
        getPage(url: next, completion: completion)
    }
    
    private func getPage(url: URL?, completion: @escaping (Result<SPTPagingObject<T>?, Error>) -> Void) {
        
        guard let url = url,
            let request = Self.forgeRequest(url: url, method: .get) else {
            completion(.success(nil))
            return
        }
        AF.request(request).responseData { response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let data = response.value else {
                completion(.failure(SPTError.noDataReceivedError))
                return
            }
            if let error = try? SPTJSONDecoder().decode(SPTError.self, from: data) {
                completion(.failure(error))
            } else {
                do {
                    let object = try SPTJSONDecoder().decode(SPTPagingObject<T>.self, from: data)
                    completion(.success(object))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private class func forgeRequest(url: URL, method: HTTPMethod) -> URLRequest? {
        guard let token = SPT.authorizationToken, !token.isEmpty else {
            print("*** Authorization token cannot be empty ***")
            return nil
        }
        let header = HTTPHeader(name: "Authorization", value: "Bearer " + token)
        guard let request = try? URLRequest(url: url, method: method, headers: HTTPHeaders(arrayLiteral: header)) else {
                return nil
        }
        return request
    }
}
