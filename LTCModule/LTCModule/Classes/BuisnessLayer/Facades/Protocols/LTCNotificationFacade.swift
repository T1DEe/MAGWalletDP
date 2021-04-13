//
//  LTCNotificationFacade.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum LTCNotificationError: Error {
    case mappingError
}

enum LTCNotificationSuccess {
    case done
    case empty
}

enum LTCNotificationState {
    case success
    case failure
}

protocol LTCNotificationFacade {
    var isNotificationsEnabled: Bool { get set }
    
    func subscribe(completion: @escaping (Result<LTCNotificationSuccess, LTCNotificationError>) -> Void)
    func unsubscribe(clearPossibleAddresses: Bool, completion: @escaping (Result<LTCNotificationSuccess, LTCNotificationError>) -> Void)
    func subscribeWallet(_ wallet: LTCWallet, completion: @escaping (Result<LTCNotificationSuccess, LTCNotificationError>) -> Void)
    func unsubscribeWallet(_ wallet: LTCWallet, completion: @escaping (Result<LTCNotificationSuccess, LTCNotificationError>) -> Void)
    func update(completion: @escaping (Result<LTCNotificationSuccess, LTCNotificationError>) -> Void)
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void)
}
