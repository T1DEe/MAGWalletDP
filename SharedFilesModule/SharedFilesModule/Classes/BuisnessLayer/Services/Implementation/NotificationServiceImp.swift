//
//  NotificationServiceImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationServiceImp: NSObject, NotificationService {
    var sharedStorage: StorageCore!
    
    var isOn: Bool {
        get {
            guard let status = sharedStorage.get(key: Constants.SharedKeys.notificationStatus, type: Bool.self) else {
                return false
            }
            return status
        }
        set {
            try? sharedStorage.set(key: Constants.SharedKeys.notificationStatus, value: newValue)
        }
    }
    
    func registerRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .alert, .sound]) { [weak self] granted, error in
            guard let self = self else {
                return
            }
            if self.isFirstGranted() {
                self.isOn = granted
            }
            if error == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                return completion(.authorized)
            
            default:
                return completion(.denied)
            }
        }
    }
    
    func updateNotificationStatus(isEnabled: Bool) {
        try? sharedStorage.set(key: Constants.SharedKeys.notificationStatus, value: isEnabled)
    }
    
    func isFirstGranted() -> Bool {
        sharedStorage.get(key: Constants.SharedKeys.notificationStatus, type: Bool.self) == nil
    }
    
    func isNotificationsEnabled() -> Bool {
        guard let status = sharedStorage.get(key: Constants.SharedKeys.notificationStatus, type: Bool.self) else {
            return false
        }
        return status
    }
    
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension NotificationServiceImp: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}
