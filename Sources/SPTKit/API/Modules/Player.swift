//
//  File.swift
//  
//
//  Created by Adam Wienconek on 18/01/2021.
//

import Foundation

public extension SPT {
    
    struct Player {
        
        private enum Method: SPTMethod {
            case transfer, resume, pause, devices, currentTrack, seek, getQueue, getRecentlyPlayed
            
            var path: String { "me/player" }
            
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
                case .getQueue:
                    return "queue"
                case .getRecentlyPlayed:
                    return "recently-played"
                }
            }
            
            var method: HTTPMethod {
                switch self {
                case .transfer, .resume, .pause, .seek:
                    return .put
                default:
                    return .get
                }
            }
        }
    }
}

public extension SPT.Player {
    
    /**
     Get information about a user’s available devices.
     */
    static func getAvailableDevices(completion: @escaping (Result<[SPTDevice], Error>) -> Void) {
        SPT.call(method: Method.devices, pathParam: nil, queryParams: nil, body: nil)  { (result: Result<Nested<SPTDevice>, Error>) in
            switch result {
            case .success(let root):
                completion(.success(root.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func transferPlayback(deviceId: String, play: Bool = true, completion: ((Error?) -> Void)?) {
        let body: [String: Any] = [
            "device_ids": [deviceId],
            "play": play
        ]
        SPT.call(method: Method.transfer, pathParam: nil, queryParams: nil, body: body, completion: completion)
    }
    
    /**
     Resume current playback on the user’s active device.
     */
    static func resumePlayback(deviceId: String? = nil, contextUri: String? = nil, uris: [String]? = nil, offset: Int? = nil, positionMs: Int? = nil, completion: ((Error?) -> Void)?) {
        var queryParams: [String: String]?
        if let deviceId = deviceId {
            queryParams = [
                "device_id": deviceId
            ]
        }
        
        var body: [String: Any] = [:]
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
        SPT.call(method: Method.resume, pathParam: nil, queryParams: queryParams, body: body, completion: completion)
    }
    
    static func getCurrentlyPlayingTrack(completion: @escaping (Result<SPTPlayback, Error>) -> Void) {
        let queryParams = [
            "market": SPT.countryCode ?? "en"
        ]
        SPT.call(method: Method.currentTrack,
                 queryParams: queryParams,
                 completion: completion)
    }
    
    static func seekToPosition(positionMs: Int, deviceId: String? = nil, completion: ((Error?) -> Void)?) {
        var queryParams = [
            "position_ms": String(positionMs)
        ]
        if let deviceId = deviceId {
            queryParams["device_id"] = deviceId
        }
        SPT.call(method: Method.seek,
                 queryParams: queryParams,
                 completion: completion)
    }
    
    @discardableResult
    static func getUserQueue(completion: @escaping (Result<UserQueueResponse, Error>) -> Void) -> URLSessionDataTask? {
        return SPT.call(method: Method.getQueue,
                        completion: completion)
    }
    
}

// - MARK: Async/Await support.
public extension SPT.Player {
    /**
     Get information about a user’s available devices.
     */
    static func getAvailableDevices() async throws -> [SPTDevice] {
        return try await withCheckedThrowingContinuation { continuation in
            self.getAvailableDevices { result in
                continuation.resume(with: result)
            }
        }
    }
    
    static func transferPlayback(deviceId: String, play: Bool = true) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.transferPlayback(deviceId: deviceId, play: play) { error in
                if let error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
    
    /**
     Resume current playback on the user’s active device.
     */
    static func resumePlayback(deviceId: String? = nil, contextUri: String? = nil, uris: [String]? = nil, offset: Int? = nil, positionMs: Int? = nil) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.resumePlayback(deviceId: deviceId,
                                contextUri: contextUri,
                                uris: uris,
                                offset: offset,
                                positionMs: positionMs) { error in
                if let error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
    
    static func getCurrentlyPlayingTrack() async throws -> SPTPlayback {
        return try await withCheckedThrowingContinuation { continuation in
            self.getCurrentlyPlayingTrack { result in
                continuation.resume(with: result)
            }
        }
    }
    
    static func seekToPosition(positionMs: Int, deviceId: String? = nil) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.seekToPosition(positionMs: positionMs,
                                deviceId: deviceId) { error in
                if let error {
                    return continuation.resume(throwing: error)
                }
                continuation.resume()
            }
        }
    }
    
    static func getUserQueue() async throws -> UserQueueResponse {
        return try await withCheckedThrowingContinuation { continuation in
            self.getUserQueue { result in
                continuation.resume(with: result)
            }
        }
    }
    
}

public struct UserQueueResponse: Decodable {
    
    public let currentlyPlaying: SPTTrack
    public let queue: [SPTTrack]
    
    private enum CodingKeys: String, CodingKey {
        case currentlyPlaying = "currently_playing"
        case queue
    }
    
}
