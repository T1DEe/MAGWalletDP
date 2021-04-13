//
//  ApplicationModuleApplicationModuleInteractor.swift
//  ETHModule
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
    var settingsConfiguration: ETHSettingsConfiguration!
    var authService: ETHAuthService!
    var updateService: ETHUpdateService!
    var applicationAssembler: ApplicationAssembler!
    var networkFacade: ETHNetworkFacade!
    var notificationFacade: ETHNotificationFacade!
}

// MARK: - ApplicationModuleInteractorInput

extension ApplicationModuleInteractor: ApplicationModuleInteractorInput {
    func changeNetwork(network: Network, useDefault: Bool) {
        networkFacade.useOnlyDefaultNetwork(useDefault)
        
        var switchNetwork: ETHNetworkType
        
        switch network {
        case .mainnet:
            switchNetwork = .mainnet
            
        case .testnet:
            switchNetwork = .rinkeby
            
        case .other:
            // You can map to other network here
            switchNetwork = .rinkeby
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
        if let network = network as? ETHNetworkType {
            networkFacade.setCurrentNetwork(network: network)
        }
    }
    
    func getIdentifiableNetworks() -> [IdentifiableNetwork] {
        return ETHNetworkType.usable
    }
    
    func getCurrentNetwork() -> IdentifiableNetwork {
        return networkFacade.getCurrentNetwork()
    }
    
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
    
    private func findWallet(_ wallet: String) throws -> ETHWallet {
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
        return R.image.eth_icon() ?? UIImage()
    }
    
    func obtainWalletName() -> String {
        return Constants.ETHConstants.ETHName
    }
    
    func obtainWalletCurrency() -> String {
        return Constants.ETHConstants.ETHSymbol
    }
    
    func obtainTokenCurrency() throws -> String {
        guard let token = settingsConfiguration.additionalToken else {
            throw AccountInfoError.noToken
        }
        return token.symbol
    }
    
    func obtainTokenName() throws -> String {
        guard let token = settingsConfiguration.additionalToken else {
            throw AccountInfoError.noToken
        }
        return token.name
    }
    
    func obtainCurrentWalletBalance(completion: @escaping AccountInfoCompletionHandler<String>) {
        obtainCurrentWalletBalance(completion: completion, notifyLocal: true)
    }
    
    func obtainCurrentTokenBalance(completion: @escaping AccountInfoCompletionHandler<String>) {
        obtainCurrentTokenBalance(completion: completion, notifyLocal: true)
    }
    
    func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>) {
        obtainBalances(completion: completion, notifyLocal: true)
    }
    
    func obtainTokenBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>) {
        obtainTokenBalances(completion: completion, notifyLocal: true)
    }
    
    func clearAssembler() {
        if let container = applicationAssembler.assembler.resolver as? Container {
            container.resetObjectScope(.container)
        }
    }
    
    func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>) {
        obtainRate(completion: completion, notifyLocal: true)
    }
    
    func obtainTokenRate(completion: @escaping AccountInfoCompletionHandler<String>) {
        obtainTokenRate(completion: completion, notifyLocal: true)
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
        let wallet = ETHWallet(address: name, network: network)
        
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
        
        let wallet = ETHWallet(address: name, network: network)
        
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
        let currency = ETHCurrency.ethCurrency
        obtainBalance(currency: currency, completion: completion, notifyLocal: notifyLocal)
    }
    
    private func obtainCurrentTokenBalance(completion: @escaping AccountInfoCompletionHandler<String>,
                                           notifyLocal: Bool) {
        guard let currency = settingsConfiguration.additionalToken else {
            completion(.failure(.noToken))
            return
        }
        
        obtainBalance(currency: currency, completion: completion, notifyLocal: notifyLocal)
    }
    
    private func obtainBalance(currency: Currency,
                               completion: @escaping AccountInfoCompletionHandler<String>,
                               notifyLocal: Bool) {
        guard let wallet = try? authService.getCurrentWallet() else {
            completion(.failure(.notAuthorized))
            return
        }

        if notifyLocal {
            let localBalance = updateService.getLocalBalanceFor(wallet: wallet, currency: currency)
            completion(.success(localBalance.valueWithDecimals))
        }
        
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { result in
            switch result {
            case .success(let balance):
                completion(.success(balance.valueWithDecimals))

            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    private func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>,
                                notifyLocal: Bool) {
        let currency = ETHCurrency.ethCurrency
        obtainBalances(currency: currency, completion: completion, notifyLocal: notifyLocal)
    }
    
    private func obtainTokenBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>,
                                     notifyLocal: Bool) {
        guard let currency = settingsConfiguration.additionalToken else {
            completion(.failure(.noToken))
            return
        }
        obtainBalances(currency: currency, completion: completion, notifyLocal: notifyLocal)
    }
    
    private func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>, notifyLocal: Bool) {
        let currency = ETHCurrency.ethCurrency
        
        if notifyLocal {
            let rate = updateService.getLocalRate(for: currency)
            completion(.success(rate))
        }
        
        updateService.obtainRate(for: currency) { result in
            switch result {
            case .success(let rate):
                completion(.success(rate.rate))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    private func obtainTokenRate(completion: @escaping AccountInfoCompletionHandler<String>, notifyLocal: Bool) {
        guard let currency = settingsConfiguration.additionalToken else {
            completion(.failure(.noToken))
            return
        }
        
        if notifyLocal {
            let rate = updateService.getLocalRate(for: currency)
            completion(.success(rate))
        }
        
        updateService.obtainRate(for: currency) { result in
            switch result {
            case .success(let rate):
                completion(.success(rate.rate))
                
            case .failure:
                completion(.failure(.innerError))
            }
        }
    }
    
    private func obtainBalances(
        currency: Currency,
        completion: @escaping AccountInfoCompletionHandler<[String: String]>,
        notifyLocal: Bool
    ) {
        guard let wallets = try? authService.getWallets() else {
            completion(.failure(.notAuthorized))
            return
        }
        
        if notifyLocal {
            let localBalances = updateService.getLocalBalancesFor(wallets: wallets, currency: currency)
            var mapped = [String: String]()
            localBalances.forEach { mapped[$0.key.address] = $0.value.valueWithDecimals.toFormattedCropNumber() }
            completion(.success(mapped))
        }
        
        updateService.updateWalletsBalances(wallets: wallets, currency: currency) { result in
            switch result {
            case .success(let balances):
                var mapped = [String: String]()
                balances.forEach { mapped[$0.key.address] = $0.value.valueWithDecimals.toFormattedCropNumber() }
                completion(.success(mapped))

            case .failure:
                completion(.failure(.innerError))
            }
        }
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
