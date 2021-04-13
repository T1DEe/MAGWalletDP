//
//  ETHNetworkFacade.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol ETHNetworkFacade {
    func getCurrentNetwork() -> ETHNetworkType
    func useOnlyDefaultNetwork(_ useDefault: Bool)
    func usingOnlyDefaultNetwork() -> Bool
    func setCurrentNetwork(network: ETHNetworkType)
    func loadSavedNetwork() -> ETHNetworkType?
}
