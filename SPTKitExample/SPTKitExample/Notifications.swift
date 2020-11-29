//
//  Notifications.swift
//  SPTKitExample
//
//  Created by Adam Wienconek on 20/09/2020.
//  Copyright © 2020 Adam Wienconek. All rights reserved.
//

import Foundation

enum Notifications {
    static let loginStatusDidChangeNotification = Notification.Name(rawValue: "loginStatusDidChangeNotification")
    
    static let applicationReceivedURL = Notification.Name(rawValue: "applicationReceivedURL")
}
