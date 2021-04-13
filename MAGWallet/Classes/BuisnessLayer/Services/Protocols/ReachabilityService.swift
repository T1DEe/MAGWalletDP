//
//  ReachabilityService.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum ReachabilityConnection {
    case reachable
    case unreachable
}

protocol ReachabilityService {
    var connection: ReachabilityConnection { get }
    
    func configure()
}
