//
//  NotificationService.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum NotificationSettings {
    case denied // was denied, go to settings
    case authorized // granted
}

public protocol NotificationService {
    var isOn: Bool { get set }
    
    func registerRemoteNotifications()
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error)
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void)
}
