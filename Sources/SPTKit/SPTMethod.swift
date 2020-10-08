//
//  File.swift
//  
//
//  Created by Adam Wienconek on 19/09/2020.
//

import Foundation
import Alamofire

protocol SPTMethod {
    static var path: String { get }
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
        components.path = Self.rootExtension + Self.path
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
