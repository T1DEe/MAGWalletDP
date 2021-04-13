//
//  ChangeNetworkInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class ChangeNetworkInteractor {
    weak var output: ChangeNetworkInteractorOutput!
}

// MARK: - ChangeNetworkInteractorInput

extension ChangeNetworkInteractor: ChangeNetworkInteractorInput {    
    func getScreenNetworks(from networks: [NetworkConfigurable]) -> ChangeNetworkScreenModel {
        var sections = [ChangeNetworkScreenSectionModel]()
        
        networks.forEach {
            let currentNetwork = $0.getCurrentNetwork()
            let section = ChangeNetworkScreenSectionModel(
                headerTitle: $0.getNetworkGroupTitle(),
                networkModels: mapIdentifiableNetworks(networks: $0.getIdentifiableNetworks(), currentNetwork: currentNetwork),
                network: $0
            )
            sections.append(section)
        }
        
        return ChangeNetworkScreenModel(sections: sections)
    }
    
    func mapIdentifiableNetworks(
        networks: [IdentifiableNetwork],
        currentNetwork: IdentifiableNetwork
    ) -> [ChangeNetworkScreenNetworkModel] {
        return networks.map {
            ChangeNetworkScreenNetworkModel(
                name: $0.name,
                isSelected: $0.isEqual(network: currentNetwork),
                identifiableNetwork: $0
            )
        }
    }
    
    func changeNetwork(network: NetworkConfigurable, identifiableNetwork: IdentifiableNetwork) {
        network.changeNetwork(identifiableNetwork: identifiableNetwork)
    }
}
