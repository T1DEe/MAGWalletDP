//
//  ChangeNetworkInteractor.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class ChangeNetworkInteractor {
    weak var output: ChangeNetworkInteractorOutput!
    var authService: LTCAuthService!
    var networkFacade: LTCNetworkFacade!
    var authActionHandler: AuthEventActionHandler!
}

// MARK: - ChangeNetworkInteractorInput

extension ChangeNetworkInteractor: ChangeNetworkInteractorInput {
    func getNetworks() -> [ChangeNetworkModel<LTCNetworkType>] {
        let models = LTCNetworkType.allCases.map {
            mapNetworkModel(network: $0)
        }
        return models
    }
    
    func changeNetwork(network: LTCNetworkType) {
        networkFacade.setCurrentNetwork(network: network)
        authActionHandler.actionNewWalletSelected()
        
        if !authService.hasWallets {
            output.didGetNoWallets()
        }
    }
    
    private func getCurrentNetwork() -> LTCNetworkType {
        return networkFacade.getCurrentNetwork()
    }
    
    private func mapNetworkModel(network: LTCNetworkType) -> ChangeNetworkModel<LTCNetworkType> {
        let currentNetwork = getCurrentNetwork()
        return ChangeNetworkModel(
            name: network.name,
            value: network,
            isSelected: network == currentNetwork
        )
    }
}
