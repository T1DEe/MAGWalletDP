//
//  ReachabilityConfigurator.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

class ReachabilityConfigurator: ConfiguratorProtocol {
    var reachabilityService: ReachabilityService!
    
    func configure() {
        reachabilityService.configure()
    }
}
