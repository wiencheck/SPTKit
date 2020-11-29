//
//  SpotifyManager.swift
//  Plum
//
//  Created by Adam Wienconek on 07/05/2020.
//  Copyright © 2020 adam.wienconek. All rights reserved.
//

import UIKit.UIAlertController

final class SpotifyManager: NSObject {
    
    private let sessionManager: SPTSessionManager
    
    private var sessionUrlObserver: Any!
    
    private var loginHandler: ((Result<String, Error>) -> Void)?
    
    init(clientID: String, redirectURL: URL) {
        let configuration = SPTConfiguration(clientID: clientID, redirectURL: redirectURL)
        sessionManager = SPTSessionManager(configuration: configuration, delegate: nil)
        super.init()
        sessionManager.delegate = self
    }
    
    func login(completion: ((Result<String, Error>) -> Void)?) {
        loginHandler = completion
        observeSessionUrl()
        sessionManager.initiateSession(with: scopes, options: .default)
    }
    
    private func observeSessionUrl() {
        guard sessionUrlObserver == nil else { return }
        sessionUrlObserver = NotificationCenter.default.addObserver(forName: Notifications.applicationReceivedURL, object: nil, queue: nil, using: { sender in
            guard let userInfo = sender.userInfo, let application = userInfo["app"] as? UIApplication, let url = userInfo["url"] as? URL, let options = userInfo["options"] as? [UIApplication.OpenURLOptionsKey: Any] else {
                return
            }
            self.sessionManager.application(application, open: url, options: options)
        })
    }
    
}

extension SpotifyManager: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        loginHandler?(.success(session.accessToken))
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        loginHandler?(.failure(error))
    }
    
    private var scopes: SPTScope {
        return [
            .userLibraryRead,
            .userLibraryModify,
            .playlistReadCollaborative,
            .playlistReadPrivate,
            .userReadCurrentlyPlaying,
            .userReadPlaybackState,
            .userReadPrivate,
            .userReadRecentlyPlayed,
            .userTopRead,
            .playlistModifyPrivate,
            .playlistModifyPublic
        ]
    }
}
