//
//  ReachabilityEventProxy.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol ReachabilityEventDelegate: AnyObject {
    func reachabilityChanged(newConnection: ReachabilityConnection)
}

protocol ReachabilityEventDelegateHandler: AnyObject {
    var delegate: ReachabilityEventDelegate? { get set }
}

protocol ReachabilityEventActionHandler {
    func actionReachabilityChanged(newConnection: ReachabilityConnection)
}

protocol ReachabilityEventProxy: ReachabilityEventActionHandler, ReachabilityEventDelegateHandler {
}
