//
//  ReachabilityServiceImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityServiceImp: ReachabilityService {
    var reachability: Reachability!
    var reachabilityActionHandler: ReachabilityEventActionHandler!
    
    var connection: ReachabilityConnection {
        return mapReachabilityStatus(connection: reachability.connection)
    }
    
    func configure() {
        reachability = try? Reachability()
        
        reachability.whenReachable = { [weak self] reachability in
            guard let self = self else {
                return
            }
            let mappedConnection = self.mapReachabilityStatus(connection: reachability.connection)
            self.reachabilityActionHandler.actionReachabilityChanged(newConnection: mappedConnection)
        }
        reachability.whenUnreachable = { [weak self] reachability in
            guard let self = self else {
                return
            }
            let mappedConnection = self.mapReachabilityStatus(connection: reachability.connection)
            self.reachabilityActionHandler.actionReachabilityChanged(newConnection: mappedConnection)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func mapReachabilityStatus(connection: Reachability.Connection) -> ReachabilityConnection {
        switch connection {
        case .cellular, .wifi:
            return .reachable
            
        case .unavailable, .none:
            return .unreachable
        }
    }
}
