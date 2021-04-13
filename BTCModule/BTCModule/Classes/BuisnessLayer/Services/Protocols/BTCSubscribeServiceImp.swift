//
//  BTCSubscribeServiceImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class BTCSubscribeServiceImp: BTCSubscribeService {
    var sharedStorage: StorageCore!
    
    func subscribeToPushNotifications(
        networkAdapter: BTCNetworkAdapter,
        addresses: [String],
        types: [BTCNotificationType],
        network: BTCNetworkType,
        completion: @escaping BTCNotificationCompletionHandler<BTCNotificationModel>
    ) {
        guard let token = sharedStorage.get(key: SharedFilesModule.Constants.SharedKeys.firebaseToken) else {
            completion(.failure(.noFirebaseToken))
            return
        }
        
        networkAdapter.subscribeToPushNotifications(
            addresses: addresses,
            firebaseToken: token,
            types: types
        ) { [weak self] result in
            guard let self = self else {
                completion(.failure(.operationError))
                return
            }
            do {
                let result = try result()
                self.storeSubscribeAddresses(result.addresses, for: network)
                self.removeFromPossibleSubscribed(result.addresses, type: .needSubscribtion, for: network)
                completion(.success(result))
            } catch {
                self.storePossibleNetworkAddresses(addresses, type: .needSubscribtion, for: network)
                completion(.failure(.mappingError))
            }
        }
    }
    
    func unsubscribePushNotifications(
        networkAdapter: BTCNetworkAdapter,
        addresses: [String],
        types: [BTCNotificationType],
        network: BTCNetworkType,
        completion: @escaping BTCNotificationCompletionHandler<BTCNotificationModel>
    ) {
        guard let token = sharedStorage.get(key: SharedFilesModule.Constants.SharedKeys.firebaseToken) else {
            completion(.failure(.noFirebaseToken))
            return
        }
        
        networkAdapter.unsubscribePushNotifications(
            addresses: addresses,
            firebaseToken: token,
            types: types
        ) { [weak self] result in
            guard let self = self else {
                completion(.failure(.operationError))
                return
            }
            do {
                let result = try result()
                self.removeFromSubscribed(addresses, for: network)
                self.removeFromPossibleSubscribed(addresses, type: .needUnsubscription, for: network)
                completion(.success(result))
            } catch {
                self.storePossibleNetworkAddresses(addresses, type: .needUnsubscription, for: network)
                completion(.failure(.mappingError))
            }
        }
    }
    
    func storeSubscribeAddresses(_ addresses: [String], for network: BTCNetworkType) {
        var networkAddresses = getSubscribeNetworkAddresses()
        let newAddresses = addresses.map { StoredSubscriberAddress(address: $0, network: network, type: .subscribed) }
        
        networkAddresses.append(contentsOf: newAddresses)
        let originalNetworkAddresses = Array(Set(networkAddresses))
        
        try? sharedStorage.set(key: Constants.NotificationConstants.subscribeKey, value: originalNetworkAddresses)
    }
    
    func removeFromSubscribed(_ addresses: [String], for network: BTCNetworkType) {
        var networkAddresses = getSubscribeNetworkAddresses()
        let newAddresses = addresses.map { StoredSubscriberAddress(address: $0, network: network, type: .subscribed) }
        
        for address in newAddresses {
            networkAddresses.removeAll { $0 == address }
        }
        
        try? sharedStorage.set(key: Constants.NotificationConstants.subscribeKey, value: networkAddresses)
    }
    
    func getSubscribeNetworkAddresses() -> [StoredSubscriberAddress] {
        guard let networkAddresses = sharedStorage.get(
            key: Constants.NotificationConstants.subscribeKey, type: [StoredSubscriberAddress].self
            ) else {
                return []
        }
        return networkAddresses
    }
    
    func storePossibleNetworkAddresses(_ addresses: [String], type: StoredSubscriberType, for network: BTCNetworkType) {
        if type == .needUnsubscription {
            removeFromPossibleSubscribed(addresses, type: .needSubscribtion, for: network)
        }
        
        var networkAddresses = getPossibleNetworkAddresses()
        let newAddresses = addresses.map { StoredSubscriberAddress(address: $0, network: network, type: type) }
        
        networkAddresses.append(contentsOf: newAddresses)
        let originalNetworkAddresses = Array(Set(networkAddresses))
        
        try? sharedStorage.set(key: Constants.NotificationConstants.possibleKey, value: originalNetworkAddresses)
    }
    
    func getPossibleNetworkAddresses() -> [StoredSubscriberAddress] {
        guard
            let networkAddresses = sharedStorage.get(key: Constants.NotificationConstants.possibleKey, type: [StoredSubscriberAddress].self)
            else {
                return []
        }
        return networkAddresses
    }
    
    func getPossibleNetworkAddresses(for type: StoredSubscriberType, and network: BTCNetworkType) -> [StoredSubscriberAddress] {
        guard let networkAddresses = sharedStorage.get(
            key: Constants.NotificationConstants.possibleKey, type: [StoredSubscriberAddress].self
            ) else {
                return []
        }
        return networkAddresses.filter { $0.type == type && $0.network == network }
    }
    
    func removeFromPossibleSubscribed(_ addresses: [String], type: StoredSubscriberType, for network: BTCNetworkType) {
        var possibleNetworkAddresses = getPossibleNetworkAddresses()
        let newAddresses = addresses.map { StoredSubscriberAddress(address: $0, network: network, type: type) }
        
        for address in newAddresses {
            possibleNetworkAddresses.removeAll { $0 == address }
        }
        
        try? sharedStorage.set(key: Constants.NotificationConstants.possibleKey, value: possibleNetworkAddresses)
    }
    
    func isSubscribed(address: String, network: BTCNetworkType) -> Bool {
        let subscribedAddresses = getSubscribeNetworkAddresses()
        let address = StoredSubscriberAddress(address: address, network: network, type: .subscribed)
        return subscribedAddresses.contains(address)
    }
    
    func clearPossibleAddresses() {
        sharedStorage.remove(key: Constants.NotificationConstants.possibleKey)
    }
}
