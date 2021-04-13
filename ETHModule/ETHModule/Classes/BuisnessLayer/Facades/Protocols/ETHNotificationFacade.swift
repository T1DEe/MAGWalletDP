//
//  ETHNotificationFacade.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

enum ETHNotificationError: Error {
    case mappingError
}

enum ETHNotificationSuccess {
    case done
    case empty
}

enum ETHNotificationState {
    case success
    case failure
}

protocol ETHNotificationFacade {
    var isNotificationsEnabled: Bool { get set }
    
    func subscribe(completion: @escaping (Result<ETHNotificationSuccess, ETHNotificationError>) -> Void)
    func unsubscribe(clearPossibleAddresses: Bool, completion: @escaping (Result<ETHNotificationSuccess, ETHNotificationError>) -> Void)
    func subscribeWallet(_ wallet: ETHWallet, completion: @escaping (Result<ETHNotificationSuccess, ETHNotificationError>) -> Void)
    func unsubscribeWallet(_ wallet: ETHWallet, completion: @escaping (Result<ETHNotificationSuccess, ETHNotificationError>) -> Void)
    func update(completion: @escaping (Result<ETHNotificationSuccess, ETHNotificationError>) -> Void)
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void)
}
