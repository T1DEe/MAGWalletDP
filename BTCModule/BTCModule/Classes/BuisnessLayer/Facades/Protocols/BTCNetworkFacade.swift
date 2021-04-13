//
//  BTCNetworkFacade.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol BTCNetworkFacade {
    func getCurrentNetwork() -> BTCNetworkType
    func useOnlyDefaultNetwork(_ useDefault: Bool)
    func usingOnlyDefaultNetwork() -> Bool
    func setCurrentNetwork(network: BTCNetworkType)
    func loadSavedNetwork() -> BTCNetworkType?
}
