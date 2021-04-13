//
//  LTCNetworkFacade.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol LTCNetworkFacade {
    func getCurrentNetwork() -> LTCNetworkType
    func useOnlyDefaultNetwork(_ useDefault: Bool)
    func usingOnlyDefaultNetwork() -> Bool
    func setCurrentNetwork(network: LTCNetworkType)
    func loadSavedNetwork() -> LTCNetworkType?
}
