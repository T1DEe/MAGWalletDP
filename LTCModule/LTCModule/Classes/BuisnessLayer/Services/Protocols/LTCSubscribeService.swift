//
//  LTCSubscribeService.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum LTCSubscribeError: Error {
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
    var network: LTCNetworkType
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

typealias LTCNotificationCompletionHandler<T> = (_ result: Result<T, LTCSubscribeError>) -> Void

protocol LTCSubscribeService {
    func subscribeToPushNotifications(networkAdapter: LTCNetworkAdapter,
                                      addresses: [String],
                                      types: [LTCNotificationType],
                                      network: LTCNetworkType,
                                      completion: @escaping LTCNotificationCompletionHandler<LTCNotificationModel>)
    func unsubscribePushNotifications(networkAdapter: LTCNetworkAdapter,
                                      addresses: [String],
                                      types: [LTCNotificationType],
                                      network: LTCNetworkType,
                                      completion: @escaping LTCNotificationCompletionHandler<LTCNotificationModel>)
    
    func storeSubscribeAddresses(_ addresses: [String], for network: LTCNetworkType)
    func getSubscribeNetworkAddresses() -> [StoredSubscriberAddress]
    func storePossibleNetworkAddresses(_ addresses: [String], type: StoredSubscriberType, for network: LTCNetworkType)
    func getPossibleNetworkAddresses() -> [StoredSubscriberAddress]
    func getPossibleNetworkAddresses(for type: StoredSubscriberType, and network: LTCNetworkType) -> [StoredSubscriberAddress]
    func isSubscribed(address: String, network: LTCNetworkType) -> Bool
    func clearPossibleAddresses()
    func removeFromPossibleSubscribed(_ addresses: [String], type: StoredSubscriberType, for network: LTCNetworkType)
}
