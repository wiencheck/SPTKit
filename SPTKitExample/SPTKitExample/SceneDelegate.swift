//
//  SceneDelegate.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 19/09/2020.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let userInfo = [
            "url": url,
        ] as [String: Any]
        NotificationCenter.default.post(name: Notifications.applicationReceivedURL, object: self, userInfo: userInfo)
    }
}

