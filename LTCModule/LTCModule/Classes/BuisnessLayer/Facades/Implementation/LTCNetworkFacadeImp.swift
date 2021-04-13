//
//  LTCNetworkFacadeImp.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class LTCNetworkFacadeImp: LTCNetworkFacade {
    var storageService: PublicDataService!
    var currentNetwork: LTCNetworkType!
    var networks: [LTCNetworkConfigurable]!
    var adapters: [LTCNetworkType: LTCNetworkAdapter]
    var useOnlyDefault: Bool
    
    init(
        networks: [LTCNetworkConfigurable],
        adapters: [LTCNetworkType: LTCNetworkAdapter],
        storageService: PublicDataService!,
        currentNetwork: LTCNetworkType,
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
    
    func getCurrentNetwork() -> LTCNetworkType {
        return currentNetwork
    }
    
    func setCurrentNetwork(network: LTCNetworkType) {
        if !useOnlyDefault {
            changeNetworks(with: network)
            do {
                try saveNetwork()
            } catch {
                print("Cant save current network")
            }
        }
    }
    
    func loadSavedNetwork() -> LTCNetworkType? {
        return loadNetwork()
    }
    
    func useOnlyDefaultNetwork(_ useDefault: Bool) {
        self.useOnlyDefault = useDefault
    }
    
    func usingOnlyDefaultNetwork() -> Bool {
        return useOnlyDefault
    }
    
    private func changeNetworks(with network: LTCNetworkType) {
        currentNetwork = network
        for network in networks {
            changeNetwork(network: network)
        }
    }
    
    private func changeNetwork(network: LTCNetworkConfigurable) {
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
    
    private func loadNetwork() -> LTCNetworkType? {
        guard let network = try? storageService.obtainPublicData(key: Constants.InfoConstants.networkKey, type: LTCNetworkType.self) else {
            return .none
        }
        return network
    }
}
