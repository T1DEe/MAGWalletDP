//
//  ChangeNetworkInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class ChangeNetworkInteractor {
    weak var output: ChangeNetworkInteractorOutput!
    var authService: BTCAuthService!
    var networkFacade: BTCNetworkFacade!
    var authActionHandler: AuthEventActionHandler!
}

// MARK: - ChangeNetworkInteractorInput

extension ChangeNetworkInteractor: ChangeNetworkInteractorInput {
    func getNetworks() -> [ChangeNetworkModel<BTCNetworkType>] {
        let models = BTCNetworkType.allCases.map {
            mapNetworkModel(network: $0)
        }
        return models
    }
    
    func changeNetwork(network: BTCNetworkType) {
        networkFacade.setCurrentNetwork(network: network)
        authActionHandler.actionNewWalletSelected()
        
        if !authService.hasWallets {
            output.didGetNoWallets()
        }
    }
    
    private func getCurrentNetwork() -> BTCNetworkType {
        return networkFacade.getCurrentNetwork()
    }
    
    private func mapNetworkModel(network: BTCNetworkType) -> ChangeNetworkModel<BTCNetworkType> {
        let currentNetwork = getCurrentNetwork()
        return ChangeNetworkModel(
            name: network.name,
            value: network,
            isSelected: network == currentNetwork
        )
    }
}
