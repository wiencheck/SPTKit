//
//  File.swift
//  
//
//  Created by Adam Wienconek on 18/01/2021.
//

import Foundation

public extension SPT {
    final class Player {
        /**
         Get information about a user’s available devices.
         */
        public class func getAvailableDevices(completion: @escaping (Result<[SPTDevice], Error>) -> Void) {
            
            SPT.shared.call(method: Method.devices, pathParam: nil, queryParams: nil, body: nil)  { (result: Result<Nested<SPTDevice>, Error>) in
                switch result {
                case .success(let root):
                    completion(.success(root.items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        public class func transferPlayback(deviceId: String, play: Bool = true, completion: ((Error?) -> Void)?) {
            
            let body: [String: Any] = [
                "device_ids": [deviceId],
                "play": play
            ]
            SPT.shared.call(method: Method.transfer, pathParam: nil, queryParams: nil, body: body, completion: completion)
        }
        
        /**
         Resume current playback on the user’s active device.
         */
        public class func resumePlayback(deviceId: String? = nil, contextUri: String? = nil, uris: [String]? = nil, offset: Int? = nil, positionMs: Int? = nil, completion: ((Error?) -> Void)?) {
            
            var queryParams: [String: String]?
            if let deviceId = deviceId {
                queryParams = [
                    "device_id": deviceId
                ]
            }
            
            var body = [String: Any]()
            if let contextUri = contextUri {
                body["context_uri"] = contextUri
            }
            if let uris = uris {
                body["uris"] = [uris.joined(separator: ",")]
            }
            if let offset = offset {
                body["offset"] = offset
            }
            if let positionMs = positionMs {
                body["position_ms"] = positionMs
            }
            SPT.shared.call(method: Method.resume, pathParam: nil, queryParams: queryParams, body: body, completion: completion)
        }
        
        public class func getCurrentlyPlayingTrack(completion: @escaping (Result<SPTPlayback, Error>) -> Void) {

            let queryParams = [
                "market": SPT.countryCode ?? "en"
            ]
            SPT.shared.call(method: Method.currentTrack, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        public class func seekToPosition(positionMs: Int, deviceId: String? = nil, completion: ((Error?) -> Void)?) {
            
            var queryParams = [
                "position_ms": String(positionMs)
            ]
            if let deviceId = deviceId {
                queryParams["device_id"] = deviceId
            }
            SPT.shared.call(method: Method.seek, pathParam: nil, queryParams: queryParams, body: nil, completion: completion)
        }
        
        private init() {}
        
        private enum Method: SPTMethod {
            case transfer, resume, pause, devices, currentTrack, seek
            
            var path: String {
                return "me/player"
            }
            
            var subpath: String? {
                switch self {
                case .transfer:
                    return nil
                case .resume:
                    return "play"
                case .pause:
                    return "pause"
                case .devices:
                    return "devices"
                case .currentTrack:
                    return "currently-playing"
                case .seek:
                    return "seek"
                }
            }
            
            var method: HTTPMethod {
                switch self {
                case .devices, .currentTrack:
                    return .get
                case .transfer, .resume, .pause, .seek:
                    return .put
                }
            }
        }
    }
}