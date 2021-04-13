//
//  BTCNotificationFacadeImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class BTCNotificationFacadeImp: BTCNotificationFacade {
    private let adapters: [BTCNetworkType: BTCNetworkAdapter]
    var authService: BTCAuthService!
    var subscribeService: BTCSubscribeService!
    var notificationService: NotificationService!
    
    private let subscribeSemaphore = DispatchSemaphore(value: 0)
    private let subscribeWorkingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    init(adapters: [BTCNetworkType: BTCNetworkAdapter]) {
        self.adapters = adapters
    }
    
    func subscribe(completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self, weak operation] in
            guard let self = self, operation?.isCancelled == false else {
                return
            }
            
            let group = DispatchGroup()
            var states = [BTCNotificationState]()
            
            for (network, adapter) in self.adapters {
                group.enter()
                
                var addresses = self.getWallets(for: network).map { $0.address }
                
                let possibleNetworkAddresses = self.subscribeService.getPossibleNetworkAddresses(
                    for: .needSubscribtion,
                    and: network
                )
                let possibleAddresses = possibleNetworkAddresses.map { $0.address }
                
                addresses.append(contentsOf: possibleAddresses)
                let originalAddresses = Array(Set(addresses))
                
                if originalAddresses.isEmpty {
                    group.leave()
                    continue
                }
                
                self.subscribeService.subscribeToPushNotifications(
                    networkAdapter: adapter,
                    addresses: originalAddresses,
                    types: [.balance, .incoming, .outgoing],
                    network: network
                ) { [weak operation] result in
                    guard operation?.isCancelled == false else {
                        group.leave()
                        return
                    }
                    
                    switch result {
                    case .success:
                        states.append(.success)
                        
                    case .failure:
                        states.append(.failure)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .global(qos: .background)) { [weak self] in
                if states.contains(.failure) {
                    completion(.failure(.mappingError))
                } else if states.isEmpty {
                    completion(.success(.empty))
                } else {
                    completion(.success(.done))
                }
                self?.subscribeSemaphore.signal()
            }
            
            self.subscribeSemaphore.wait()
        }
        
        subscribeWorkingQueue.addOperation(operation)
    }
    
    func unsubscribe(
        clearPossibleAddresses: Bool = false,
        completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void
    ) {
        if clearPossibleAddresses {
            subscribeService.clearPossibleAddresses()
        }
        
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self, weak operation] in
            guard let self = self, operation?.isCancelled == false else {
                return
            }
            
            let group = DispatchGroup()
            var states = [BTCNotificationState]()
            
            for (network, adapter) in self.adapters {
                group.enter()
                
                let networkAddresses = self.subscribeService.getSubscribeNetworkAddresses().filter { $0.network == network }
                let originalAddresses = networkAddresses.map { $0.address }
                
                if originalAddresses.isEmpty {
                    group.leave()
                    continue
                }
                
                self.subscribeService.unsubscribePushNotifications(
                    networkAdapter: adapter,
                    addresses: originalAddresses,
                    types: [],
                    network: network
                ) { [weak operation] result in
                    guard operation?.isCancelled == false else {
                        group.leave()
                        return
                    }
                    
                    switch result {
                    case .success:
                        states.append(.success)
                        
                    case .failure:
                        states.append(.failure)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .global(qos: .background)) { [weak self] in
                if states.contains(.failure) {
                    completion(.failure(.mappingError))
                } else if states.isEmpty {
                    completion(.success(.empty))
                } else {
                    completion(.success(.done))
                }
                self?.subscribeSemaphore.signal()
            }
            
            self.subscribeSemaphore.wait()
        }
        
        subscribeWorkingQueue.addOperation(operation)
    }
    
    func subscribeWallet(_ wallet: BTCWallet, completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void) {
        guard let adapter = adapters[wallet.network] else {
            return
        }
        
        subscribeService.subscribeToPushNotifications(
            networkAdapter: adapter,
            addresses: [wallet.address],
            types: [.balance, .incoming, .outgoing],
            network: wallet.network
        ) { result in
            switch result {
            case .success:
                completion(.success(.done))
                
            case .failure:
                completion(.failure(.mappingError))
            }
        }
    }
    
    func unsubscribeWallet(_ wallet: BTCWallet, completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void) {
        guard let adapter = adapters[wallet.network] else {
            return
        }
        
        if subscribeService.isSubscribed(address: wallet.address, network: wallet.network) {
            subscribeService.unsubscribePushNotifications(
                networkAdapter: adapter,
                addresses: [wallet.address],
                types: [],
                network: wallet.network
            ) { result in
                switch result {
                case .success:
                    completion(.success(.done))
                    
                case .failure:
                    completion(.failure(.mappingError))
                }
            }
        } else {
            subscribeService.removeFromPossibleSubscribed([wallet.address], type: .needSubscribtion, for: wallet.network)
            subscribeService.removeFromPossibleSubscribed([wallet.address], type: .needUnsubscription, for: wallet.network)
        }
    }
    
    func update(completion: @escaping (Result<BTCNotificationSuccess, BTCNotificationError>) -> Void) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self, weak operation] in
            guard let self = self, operation?.isCancelled == false else {
                return
            }
            
            var states = [BTCNotificationState]()
            let group = DispatchGroup()
            
            for (network, adapter) in self.adapters {
                let subscriptionAddresses = self.subscribeService.getPossibleNetworkAddresses(for: .needSubscribtion, and: network)
                
                let networkAddresses = self.subscribeService.getSubscribeNetworkAddresses().filter { $0.network == network }
                let possibleUnsubscriptionAddresses = self.subscribeService.getPossibleNetworkAddresses(for: .needUnsubscription, and: network)
                let unsubscriptionAddresses = self.getAddressesIntersection(first: networkAddresses, second: possibleUnsubscriptionAddresses)
                
                if !subscriptionAddresses.isEmpty {
                    group.enter()
                    
                    let addresses = subscriptionAddresses.map { $0.address }
                    self.subscribeService.subscribeToPushNotifications(
                        networkAdapter: adapter,
                        addresses: addresses,
                        types: [.balance, .incoming, .outgoing],
                        network: network
                    ) { [weak operation] result in
                        guard operation?.isCancelled == false else {
                            group.leave()
                            return
                        }
                        
                        switch result {
                        case .success:
                            states.append(.success)
                            
                        case .failure:
                            states.append(.failure)
                        }
                        
                        group.leave()
                    }
                }
                
                if !unsubscriptionAddresses.isEmpty {
                    group.enter()
                    
                    let addresses = unsubscriptionAddresses.map { $0.address }
                    self.subscribeService.unsubscribePushNotifications(
                        networkAdapter: adapter,
                        addresses: addresses,
                        types: [],
                        network: network
                    ) { [weak operation] result in
                        guard operation?.isCancelled == false else {
                            group.leave()
                            return
                        }
                        
                        switch result {
                        case .success:
                            states.append(.success)
                            
                        case .failure:
                            states.append(.failure)
                        }
                        
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .global(qos: .background)) {
                if states.contains(.failure) {
                    completion(.failure(.mappingError))
                } else {
                    completion(.success(.done))
                }
                self.subscribeSemaphore.signal()
            }
            
            self.subscribeSemaphore.wait()
        }
        
        subscribeWorkingQueue.addOperation(operation)
    }
    
    var isNotificationsEnabled: Bool {
        get {
            return notificationService.isOn
        }
        set {
            notificationService.isOn = newValue
        }
    }
    
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void) {
        notificationService.getNotificationStatus(completion: completion)
    }
    
    func getWallets(for network: BTCNetworkType) -> [BTCWallet] {
        guard let wallets = try? authService.getAllWallets() else {
            return []
        }
        return wallets.filter { $0.network == network }
    }
    
    func getAddressesIntersection(first: [StoredSubscriberAddress], second: [StoredSubscriberAddress]) -> [StoredSubscriberAddress] {
        var addresses = [StoredSubscriberAddress]()
        
        for address in first {
            if let item = second.first(where: {
                $0.address.uppercased() == address.address.uppercased() && $0.network == address.network
            }) {
                addresses.append(item)
            }
        }
        
        return addresses
    }
}
