//
//  BTCSubscribeService.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum BTCSubscribeError: Error {
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
    var network: BTCNetworkType
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

typealias BTCNotificationCompletionHandler<T> = (_ result: Result<T, BTCSubscribeError>) -> Void

protocol BTCSubscribeService {
    func subscribeToPushNotifications(networkAdapter: BTCNetworkAdapter,
                                      addresses: [String],
                                      types: [BTCNotificationType],
                                      network: BTCNetworkType,
                                      completion: @escaping BTCNotificationCompletionHandler<BTCNotificationModel>)
    func unsubscribePushNotifications(networkAdapter: BTCNetworkAdapter,
                                      addresses: [String],
                                      types: [BTCNotificationType],
                                      network: BTCNetworkType,
                                      completion: @escaping BTCNotificationCompletionHandler<BTCNotificationModel>)
    
    func storeSubscribeAddresses(_ addresses: [String], for network: BTCNetworkType)
    func getSubscribeNetworkAddresses() -> [StoredSubscriberAddress]
    func storePossibleNetworkAddresses(_ addresses: [String], type: StoredSubscriberType, for network: BTCNetworkType)
    func getPossibleNetworkAddresses() -> [StoredSubscriberAddress]
    func getPossibleNetworkAddresses(for type: StoredSubscriberType, and network: BTCNetworkType) -> [StoredSubscriberAddress]
    func isSubscribed(address: String, network: BTCNetworkType) -> Bool
    func clearPossibleAddresses()
    func removeFromPossibleSubscribed(_ addresses: [String], type: StoredSubscriberType, for network: BTCNetworkType)
}
