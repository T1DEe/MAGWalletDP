//
//  FlowNotificationFacade.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum FlowNotificationState {
    case success
    case failure
}

enum FlowNotificationResult {
    case success
}

enum FlowNotificationError: Error {
    case failure
}

protocol FlowNotificationFacade {
    var isNotificationsEnabled: Bool { get set }
    
    func subscribe(flows: [Notifiable], completion: @escaping (Result<FlowNotificationResult, FlowNotificationError>) -> Void)
    func unsubscribe(flows: [Notifiable],
                     clearPossibleAddresses: Bool,
                     completion: @escaping (Result<FlowNotificationResult, FlowNotificationError>) -> Void)
    func update(flows: [Notifiable])
    func subscribeAddress(address: String, flow: Notifiable)
    func unsubscribeAddress(address: String, flow: Notifiable)
    func updateToken(flows: [Notifiable])
    
    func registerRemoteNotifications()
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error)
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void)
}
