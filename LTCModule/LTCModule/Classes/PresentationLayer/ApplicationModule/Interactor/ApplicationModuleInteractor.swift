//
//  ApplicationModuleInteractor.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import Swinject
import UIKit

class ApplicationModuleInteractor {
    weak var output: ApplicationModuleInteractorOutput!
    var snackBarsHandler: SnackBarsEventDelegateHandler!
    var sensitiveDataDelegateHandler: SensitiveDataEventProxy!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var settingsConfiguration: LTCSettingsConfiguration!
    var authService: LTCAuthService!
    var updateService: LTCUpdateService!
    var applicationAssembler: ApplicationAssembler!
    var networkFacade: LTCNetworkFacade!
    var notificationFacade: LTCNotificationFacade!
}

// MARK: - ApplicationModuleInteractorInput

extension ApplicationModuleInteractor: ApplicationModuleInteractorInput {    
    func bindToEvents() {
        snackBarsHandler.delegate = self
        sensitiveDataDelegateHandler.delegate = self
    }
    
    func hasWallets() -> Bool {
        return authService.hasWallets
    }
    
    func obtainCurrentWallet() throws -> String {
        guard let currentWallet = try? authService.getCurrentWallet() else {
            throw AccountInfoError.notAuthorized
        }
        
        return currentWallet.address
    }
    
    func obtainWallets() throws -> [String] {
        guard let wallets = try? authService.getWallets() else {
            throw AccountInfoError.notAuthorized
        }
        
        return wallets.map { $0.address }
    }
    
    func selectWallet(_ wallet: String) throws {
        let wallet = try findWallet(wallet)
        
        do {
            try authService.selectWallet(wallet)
        } catch {
            throw AccountInfoError.accountNotExist
        }
    }
    
    func deleteWallet(_ wallet: String) throws {
        let wallet = try findWallet(wallet)
        
        do {
            try authService.deleteWallet(wallet)
            
            let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: wallet)
            let command = SecureDataRemoveCommand(key: key) { _ in }
            output.processSensitiveDataCommand(command)
        } catch {
            throw AccountInfoError.accountNotExist
        }
    }
    
    private func findWallet(_ wallet: String) throws -> LTCWallet {
        guard let wallets = try? authService.getWallets() else {
            throw AccountInfoError.notAuthorized
        }
        
        guard let wallet = wallets.first(where: { $0.address == wallet }) else {
            throw AccountInfoError.accountNotExist
        }
        return wallet
    }
    
    func obtainConfiguration() -> SettingsConfiguration {
        return settingsConfiguration
    }
    
    func obtainWalletIcon() -> UIImage {
        return R.image.ltc_icon() ?? UIImage()
    }
    
    func obtainWalletName() -> String {
        return Constants.LTCConstants.LTCName
    }
    
    func obtainWalletCurrency() -> String {
        return Constants.LTCConstants.LTCSymbol
    }

    func obtainCurrentWalletBalance(completion: @escaping AccountInfoCompletionHandler<String>) {
        obtainCurrentWalletBalance(completion: completion, notifyLocal: true)
    }

    func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>) {
        obtainBalances(completion: completion, notifyLocal: true)
    }
    
    func clearAssembler() {
        if let container = applicationAssembler.assembler.resolver as? Container {
            container.resetObjectScope(.container)
        }
    }
    
    func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>) {
        obtainRate(completion: completion, notifyLocal: true)
    }
    
    func changeNetwork(network: Network, useDefault: Bool) {
        networkFacade.useOnlyDefaultNetwork(useDefault)
        
        var switchNetwork: LTCNetworkType
        
        switch network {
        case .mainnet:
            switchNetwork = .mainnet
            
        case .testnet:
            switchNetwork = .testnet
            
        case .other:
            // You can map to other networks here
            switchNetwork = .testnet
        }
        
        if useDefault {
            networkFacade.setCurrentNetwork(network: switchNetwork)
        } else {
            if let savedNetwork = networkFacade.loadSavedNetwork() {
                networkFacade.setCurrentNetwork(network: savedNetwork)
            } else {
                networkFacade.setCurrentNetwork(network: switchNetwork)
            }
        }
    }
    
    func changeNetwork(network: IdentifiableNetwork) {
        if let network = network as? LTCNetworkType {
            networkFacade.setCurrentNetwork(network: network)
        }
    }
    
    func getIdentifiableNetworks() -> [IdentifiableNetwork] {
        return LTCNetworkType.allCases
    }
    
    func getCurrentNetwork() -> IdentifiableNetwork {
        return networkFacade.getCurrentNetwork()
    }
    
    func subscribeToPushNotifications(completion: @escaping NotifiableCompletionHandler<Void>) {
        notificationFacade.subscribe { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    func unsubscribePushNotifications(clearPossibleAddresses: Bool, completion: @escaping NotifiableCompletionHandler<Void>) {
        notificationFacade.unsubscribe(clearPossibleAddresses: clearPossibleAddresses) { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    func updatePushNotification(completion: @escaping NotifiableCompletionHandler<Void>) {
        notificationFacade.update { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    func subscribeAccount(name: String, completion: @escaping NotifiableCompletionHandler<Void>) {
        let network = networkFacade.getCurrentNetwork()
        let wallet = LTCWallet(address: name, network: network)
        
        notificationFacade.subscribeWallet(wallet) { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    func unsubscribeAccount(name: String, completion: @escaping NotifiableCompletionHandler<Void>) {
        let network = networkFacade.getCurrentNetwork()
        let wallet = LTCWallet(address: name, network: network)
        
        notificationFacade.unsubscribeWallet(wallet) { result in
            switch result {
            case .success:
                completion(.success(()))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    // MARK: Private
    
    private func obtainCurrentWalletBalance(completion: @escaping AccountInfoCompletionHandler<String>,
                                            notifyLocal: Bool) {
        guard let wallet = try? authService.getCurrentWallet() else {
            completion(.failure(.notAuthorized))
            return
        }
        
        if notifyLocal {
            let localBalance = updateService.getLocalBalanceFor(wallet: wallet)
            let convertedBalance = satoshiToLTC(satoshi: localBalance)
            completion(.success(convertedBalance))
        }
        
        updateService.updateWalletBalance(wallet: wallet) { [weak self] result in
            switch result {
            case .success(let balance):
                let convertedBalance = self?.satoshiToLTC(satoshi: balance)
                completion(.success(convertedBalance ?? "0"))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    private func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>,
                            notifyLocal: Bool) {
        if notifyLocal {
            let localRate = updateService.getLocalRate()
            completion(.success(localRate))
        }
        
        updateService.obtainRate { result in
            switch result {
            case .success(let model):
                completion(.success(model.rate))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    private func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>,
                                notifyLocal: Bool) {
        guard let wallets = try? authService.getWallets() else {
            completion(.failure(.notAuthorized))
            return
        }

        if notifyLocal {
            let localBalances = updateService.getLocalBalancesFor(wallets: wallets)
            let mappedBalances = mapBalances(balances: localBalances)
            completion(.success(mappedBalances))
        }
        
        updateService.updateWalletsBalances(wallets: wallets) { [weak self] result in
            switch result {
            case .success(let balances):
                guard let mappedBalances = self?.mapBalances(balances: balances) else {
                    completion(.failure(.innerError))
                    return
                }
                completion(.success(mappedBalances))

            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    private func mapBalances(balances: [LTCWallet: String]) -> [String: String] {
        var mappedBalances = [String: String]()
        balances.forEach { item in
            let amount = satoshiToLTC(satoshi: item.value)
            mappedBalances[item.key.address] = amount
        }
        
        return mappedBalances
    }
    
    private func satoshiToLTC(satoshi: String) -> String {
        guard let satoshi = Int(satoshi) else {
            return "0"
        }
        return BigDecimalNumber(satoshi).powerOfMinusTen(BigDecimalNumber(Constants.LTCConstants.LTCDecimal))
    }
}

// MAKR: - SnackBarsEventDelegate

extension ApplicationModuleInteractor: SnackBarsEventDelegate {
    func didPresentSnackBar(_ snackBar: SnackBarPresentable) {
        output.presentSnackBar(snackBar)
    }
}

extension ApplicationModuleInteractor: SensitiveDataEventDelegate {
    func didProcessCommand(_ command: SecureDataCommand) {
        output.processSensitiveDataCommand(command)
    }
}
