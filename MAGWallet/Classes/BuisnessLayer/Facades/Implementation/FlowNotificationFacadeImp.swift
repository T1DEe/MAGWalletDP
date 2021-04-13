//
//  FlowNotificationService.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class FlowNotificationFacadeImp: FlowNotificationFacade {
    var notificationService: NotificationService!
    var firebaseService: FirebaseService!
    
    var isNotificationsEnabled: Bool {
        get {
            return notificationService.isOn
        }
        set {
            notificationService.isOn = newValue
        }
    }
    
    func registerRemoteNotifications() {
        notificationService.registerRemoteNotifications()
    }
    
    func application(didFailToRegisterForRemoteNotificationsWithError error: Error) {
        notificationService.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void) {
        return notificationService.getNotificationStatus(completion: completion)
    }

    func subscribe(flows: [Notifiable], completion: @escaping (Result<FlowNotificationResult, FlowNotificationError>) -> Void) {
        let group = DispatchGroup()
        var states = [FlowNotificationState]()
        
        for flow in flows {
            group.enter()
            
            flow.subscribeAll { result in
                switch result {
                case .success:
                    states.append(.success)
                    
                case .failure(let error):
                    switch error {
                    case .innerError:
                        states.append(.failure)
                        
                    default:
                        break
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .background)) {
            if states.contains(.failure) {
                completion(.failure(.failure))
            } else {
                completion(.success(.success))
            }
        }
    }
    
    func unsubscribe(
        flows: [Notifiable],
        clearPossibleAddresses: Bool,
        completion: @escaping (Result<FlowNotificationResult, FlowNotificationError>) -> Void
    ) {
        let group = DispatchGroup()
        var states = [FlowNotificationState]()
        
        for flow in flows {
            group.enter()
            
            flow.unsubscribeAll(clearPossibleAddresses: clearPossibleAddresses) { result in
                switch result {
                case .success:
                    states.append(.success)
                    
                case .failure(let error):
                    switch error {
                    case .innerError:
                        states.append(.failure)
                        
                    default:
                        break
                    }
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .background)) {
            if states.contains(.failure) {
                completion(.failure(.failure))
            } else {
                completion(.success(.success))
            }
        }
    }
    
    func update(flows: [Notifiable]) {
        for flow in flows {
            flow.updateAll { result in
                if case .failure(let error) = result, case .innerError = error {
                    print("Failed to unsubscribe")
                }
            }
        }
    }
    
    func subscribeAddress(address: String, flow: Notifiable) {
        flow.subscribeAddress(address: address) { result in
            switch result {
            case .success:
                print("Successfully subscribe \(address)")
                
            case .failure(let error):
                switch error {
                case .innerError:
                    print("Cant unsubscribe \(address). Add to possible unsubscribe")
                    
                case .notSupported:
                    print("Not supported")
                }
            }
        }
    }
    
    func unsubscribeAddress(address: String, flow: Notifiable) {
        flow.unsubscribeAddress(address: address) { result in
            switch result {
            case .success:
                print("Successfully unsubscribe \(address)")
                
            case .failure(let error):
                switch error {
                case .innerError:
                    print("Cant unsubscribe \(address). Add to possible unsubscribe")
                    
                case .notSupported:
                    print("Not supported")
                }
            }
        }
    }
    
    func updateToken(flows: [Notifiable]) {
        if let token = firebaseService.token, let previousToken = firebaseService.previousToken,
            token != previousToken, isNotificationsEnabled {
            subscribe(flows: flows) { [weak self] result in
                switch result {
                case .success:
                    self?.firebaseService.previousToken = .none
                    print("Resubscribed with new token")
                    
                case .failure:
                    print("Failed to resubscribe with new token")
                }
            }
        }
    }
}
