//
//  AppDelegate.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 19/09/2020.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: Notifications.applicationReceivedURL,
                                        object: self,
                                        userInfo: [
                                            "url": url,
                                            "options": options
                                        ])
        
        return true
    }
    
}

