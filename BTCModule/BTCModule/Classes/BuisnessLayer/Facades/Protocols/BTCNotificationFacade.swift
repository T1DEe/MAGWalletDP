//
//  BTCNotificationFacade.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum BTCNotificationError: Error {
    case mappingError
}

enum BTCNotificationSuccess {
    case done
    case empty
}

enum BTCNotificationState {
    case success
    case failure
}

protocol BTCNotificationFacade {
    var isNotificationsEnabled: Bool { get set }
    
    func subscribe(completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void)
    func unsubscribe(clearPossibleAddresses: Bool, completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void)
    func subscribeWallet(_ wallet: BTCWallet, completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void)
    func unsubscribeWallet(_ wallet: BTCWallet, completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void)
    func update(completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void)
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void)
}
