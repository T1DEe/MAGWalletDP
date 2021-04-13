//
//  ETHNotificationAddressService.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum ETHSubscribeError: Error {
    case noFirebaseToken
    case operationError
    case mappingError
}

enum StoredSubscriberType: Int, Codable {
    case subscribed
    case needSubscribtion
    case needUnsubscription
}

struct StoredSubscriberAddress: Codable, Hashable {
    var address: String
    var network: ETHNetworkType
    var type: StoredSubscriberType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(address)
        hasher.combine(network)
        hasher.combine(type)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.address.uppercased() == rhs.address.uppercased() && lhs.type == rhs.type && lhs.network == rhs.network
    }
}

typealias ETHNotificationCompletionHandler<T> = (_ result: Result<T, ETHSubscribeError>) -> Void

protocol ETHSubscribeService {
    func subscribeToPushNotifications(networkAdapter: ETHNetworkAdapter,
                                      addresses: [String],
                                      types: [ETHNotificationType],
                                      network: ETHNetworkType,
                                      completion: @escaping ETHNotificationCompletionHandler<ETHNotificationModel>)
    func unsubscribePushNotifications(networkAdapter: ETHNetworkAdapter,
                                      addresses: [String],
                                      types: [ETHNotificationType],
                                      network: ETHNetworkType,
                                      completion: @escaping ETHNotificationCompletionHandler<ETHNotificationModel>)
    
    func storeSubscribeAddresses(_ addresses: [String], for network: ETHNetworkType)
    func getSubscribeNetworkAddresses() -> [StoredSubscriberAddress]
    func storePossibleNetworkAddresses(_ addresses: [String], type: StoredSubscriberType, for network: ETHNetworkType)
    func getPossibleNetworkAddresses() -> [StoredSubscriberAddress]
    func getPossibleNetworkAddresses(for type: StoredSubscriberType, and network: ETHNetworkType) -> [StoredSubscriberAddress]
    func isSubscribed(address: String, network: ETHNetworkType) -> Bool
    func removeFromPossibleSubscribed(_ addresses: [String], type: StoredSubscriberType, for network: ETHNetworkType)
    func clearPossibleAddresses()
}
