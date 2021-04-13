//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by rlxone on 10.06.2020.
//  Copyright © 2021. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            guard let type = bestAttemptContent.userInfo["type"] as? String else {
                return
            }
            
            switch type {
            case "incoming":
                bestAttemptContent.title = R.string.localization.notificationTransactionIncomingTitle()
                
            case "outgoing":
                bestAttemptContent.title = R.string.localization.notificationTransactionOutgoingTitle()
                
            default:
                bestAttemptContent.title = R.string.localization.notificationTransactionOutgoingTitle()
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
