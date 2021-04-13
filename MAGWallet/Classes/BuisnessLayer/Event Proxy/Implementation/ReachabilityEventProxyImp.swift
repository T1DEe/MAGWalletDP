//
//  ReachabilityEventProxyImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class ReachabilityEventProxyImp: ReachabilityEventProxy {
    weak var delegate: ReachabilityEventDelegate?
    
    func actionReachabilityChanged(newConnection: ReachabilityConnection) {
        delegate?.reachabilityChanged(newConnection: newConnection)
    }
}
