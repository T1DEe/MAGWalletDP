//
//  ChangeNetworkInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class ChangeNetworkInteractor {
    weak var output: ChangeNetworkInteractorOutput!
    var authService: ETHAuthService!
    var networkFacade: ETHNetworkFacade!
    var authActionHandler: AuthEventActionHandler!
}

// MARK: - ChangeNetworkInteractorInput

extension ChangeNetworkInteractor: ChangeNetworkInteractorInput {
    func getNetworks() -> [ChangeNetworkModel<ETHNetworkType>] {
        let models = ETHNetworkType.usable.map {
            mapNetworkModel(network: $0)
        }
        return models
    }
    
    func changeNetwork(network: ETHNetworkType) {
        networkFacade.setCurrentNetwork(network: network)
        authActionHandler.actionNewWalletSelected()
        
        if !authService.hasWallets {
            output.didGetNoWallets()
        }
    }
    
    private func mapNetworkModel(network: ETHNetworkType) -> ChangeNetworkModel<ETHNetworkType> {
        let currentNetwork = networkFacade.getCurrentNetwork()
        return ChangeNetworkModel(
            name: network.name,
            value: network,
            isSelected: network == currentNetwork
        )
    }
}
