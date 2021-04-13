//
//  BTCNetworkFacadeImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class BTCNetworkFacadeImp: BTCNetworkFacade {
    var storageService: PublicDataService!
    var currentNetwork: BTCNetworkType!
    var networks: [BTCNetworkConfigurable]!
    var adapters: [BTCNetworkType: BTCNetworkAdapter]
    var useOnlyDefault: Bool
    
    init(
        networks: [BTCNetworkConfigurable],
        adapters: [BTCNetworkType: BTCNetworkAdapter],
        storageService: PublicDataService!,
        currentNetwork: BTCNetworkType,
        useOnlyDefault: Bool
    ) {
        self.currentNetwork = currentNetwork
        self.networks = networks
        self.adapters = adapters
        self.useOnlyDefault = useOnlyDefault
        self.storageService = storageService
        
        configure()
    }
    
    private func configure() {
        if useOnlyDefault {
            changeNetworks(with: currentNetwork)
        } else {
            if let network = loadNetwork() {
                changeNetworks(with: network)
            } else {
                changeNetworks(with: currentNetwork)
            }
        }
    }
    
    func getCurrentNetwork() -> BTCNetworkType {
        return currentNetwork
    }
    
    func setCurrentNetwork(network: BTCNetworkType) {
        if !useOnlyDefault {
            changeNetworks(with: network)
            do {
                try saveNetwork()
            } catch {
                print("Cant save current network")
            }
        }
    }
    
    func loadSavedNetwork() -> BTCNetworkType? {
        return loadNetwork()
    }
    
    func useOnlyDefaultNetwork(_ useDefault: Bool) {
        self.useOnlyDefault = useDefault
    }
    
    func usingOnlyDefaultNetwork() -> Bool {
        return useOnlyDefault
    }
    
    private func changeNetworks(with network: BTCNetworkType) {
        currentNetwork = network
        for network in networks {
            changeNetwork(network: network)
        }
    }
    
    private func changeNetwork(network: BTCNetworkConfigurable) {
        if let adapter = adapters[currentNetwork] {
            network.configure(with: adapter)
            network.configure(with: currentNetwork)
        } else {
            fatalError("No adapters for current network, be sure you register one.")
        }
    }
    
    private func saveNetwork() throws {
        try storageService.setPublicData(key: Constants.InfoConstants.networkKey, data: currentNetwork)
    }
    
    private func loadNetwork() -> BTCNetworkType? {
        guard let network = try? storageService.obtainPublicData(key: Constants.InfoConstants.networkKey, type: BTCNetworkType.self) else {
            return .none
        }
        return network
    }
}
