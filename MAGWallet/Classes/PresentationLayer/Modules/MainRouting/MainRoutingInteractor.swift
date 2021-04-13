//
//  MainRoutingMainRoutingInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BTCModule
import ETHModule
import Foundation
import LTCModule
import SharedFilesModule

class MainRoutingInteractor {
    weak var output: MainRoutingInteractorOutput!
    var secureCommands = [SecureDataCommand]()
    var authFacade: AuthFacade!
    var sensitiveDataService: SensitiveDataService!
    var flowNotificationFacade: FlowNotificationFacade!
    var authActionHandler: AuthEventActionHandler!
    var firebaseActionHandler: FirebaseTokenEventProxy!
    var reachabilityActionHandler: ReachabilityEventDelegateHandler!
    var preventExpireActionHandler: SessionExpirePreventActionHandler!
    var sessionTimeoutDelegateHandler: SessionTimeoutDelegateHandler!
    var snackBarsHandler: SnackBarsEventDelegateHandler!
    var firebaseService: FirebaseService!
    var flows = [ModularSubflow]()
}

// MARK: - MainRoutingInteractorInput

extension MainRoutingInteractor: MainRoutingInteractorInput {
    func bindToEvents() {
        sessionTimeoutDelegateHandler.timeoutDelegate = self
        snackBarsHandler.delegate = self
        reachabilityActionHandler.delegate = self
        firebaseActionHandler.delegate = self
    }
    
    func prepareFlows() -> [ModularSubflow] {
        var flows = [ModularSubflow]()
        var isUniqueWallet = false
        var isMultiWallet = false
        #if ETH
        isUniqueWallet = true
        isMultiWallet = false
        let ethFlow = ETHModule.ApplicationModuleModuleConfigurator().configureModule()
        configEthFlow(flow: ethFlow, isUniqueWallet: isUniqueWallet, isMultiWallet: isMultiWallet)
        flows = [ethFlow]
        #elseif BTC
        isUniqueWallet = true
        isMultiWallet = false
        let btcFlow = BTCModule.ApplicationModuleModuleConfigurator().configureModule()
        configBtcFlow(flow: btcFlow, isUniqueWallet: isUniqueWallet, isMultiWallet: isMultiWallet)
        flows = [btcFlow]
        #elseif LTC
        isUniqueWallet = true
        isMultiWallet = false
        let ltcFlow = LTCModule.ApplicationModuleModuleConfigurator().configureModule()
        configLtcFlow(flow: ltcFlow, isUniqueWallet: isUniqueWallet, isMultiWallet: isMultiWallet)
        flows = [ltcFlow]
        #else
        isUniqueWallet = false
        isMultiWallet = true
        let ethFlow = ETHModule.ApplicationModuleModuleConfigurator().configureModule()
        configEthFlow(flow: ethFlow, isUniqueWallet: isUniqueWallet, isMultiWallet: isMultiWallet)
        let btcFlow = BTCModule.ApplicationModuleModuleConfigurator().configureModule()
        configBtcFlow(flow: btcFlow, isUniqueWallet: isUniqueWallet, isMultiWallet: isMultiWallet)
        let ltcFlow = LTCModule.ApplicationModuleModuleConfigurator().configureModule()
        configLtcFlow(flow: ltcFlow, isUniqueWallet: isUniqueWallet, isMultiWallet: isMultiWallet)
        flows = [ethFlow, btcFlow, ltcFlow]
        #endif
        
        self.flows = flows
        configSnackBarsPresent(flows)
        configSecureDataFor(flows)
        configGlobalLogout(flows)
        configChangePin(flows)
        configShowWebView(flows)
        return flows
    }
    
    func configEthFlow(flow: ETHModule.ApplicationModuleModuleInput, isUniqueWallet: Bool, isMultiWallet: Bool) {
        flow.changeNetwork(network: .testnet, useOnlyDefaultNetwork: false)
        var configuration = flow.obtainConfiguration()
        configuration.isUniqueWallet = isUniqueWallet
        configuration.isMultiWallet = isMultiWallet
        if let configuration = configuration as? ETHSettingsConfiguration {
            let token = SharedFilesModule.Currency(id: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
                                                   name: "USD Coin",
                                                   symbol: "USD Coin",
                                                   decimals: 6,
                                                   isToken: true)
            configuration.additionalToken = token
        }
    }
    
    func configBtcFlow(flow: BTCModule.ApplicationModuleModuleInput, isUniqueWallet: Bool, isMultiWallet: Bool) {
        flow.changeNetwork(network: .testnet, useOnlyDefaultNetwork: false)
        var configuration = flow.obtainConfiguration()
        configuration.isUniqueWallet = isUniqueWallet
        configuration.isMultiWallet = isMultiWallet
    }
    
    func configLtcFlow(flow: LTCModule.ApplicationModuleModuleInput, isUniqueWallet: Bool, isMultiWallet: Bool) {
        flow.changeNetwork(network: .testnet, useOnlyDefaultNetwork: false)
        var configuration = flow.obtainConfiguration()
        configuration.isUniqueWallet = isUniqueWallet
        configuration.isMultiWallet = isMultiWallet
    }
    
    func makeGlobalLogout() {
        flows.forEach { $0.clear() }        //clear all assemblies
        authActionHandler.actionLogout()
        unsubscribeFlows()
    }
    
    func unsubscribeFlows() {
        flowNotificationFacade.unsubscribe(flows: flows, clearPossibleAddresses: true) { result in
            switch result {
            case .success:
                print("Successfully unsubscribed")
                
            case .failure:
                print("Failed to unsubscribe")
            }
        }
    }
    
    // MARK: Session Expiration
    func expirePreventAction() {
        preventExpireActionHandler.preventSeesionExpireAction()
    }
    
    func isSessionExpired() -> Bool {
        return preventExpireActionHandler.isSessionExpire()
    }
    
    func startExpirationMonitoring() {
        preventExpireActionHandler.startMonitoring()
    }
    
    func stopExpirationMonitoring() {
        preventExpireActionHandler.stopMonitoring()
    }
    
    // MARK: Config
    
    private func configSnackBarsPresent(_ flows: [ModularSubflow]) {
        flows.forEach {
            configSnackBarsPresent($0)
        }
    }
    
    private func configChangePin(_ flows: [ModularSubflow]) {
        flows.forEach {
            $0.changePinHandler = { [weak self] in
                self?.changePin()
            }
        }
    }
    
    private func configGlobalLogout(_ flows: [ModularSubflow]) {
        flows.forEach {
            $0.didFinishAllFlows = { [weak self] in
                self?.privateLogout()
            }
        }
    }
    
    private func configSnackBarsPresent(_ flow: ModularSubflow) {
        flow.presentHandler = { [weak self] snackBar in
            self?.output?.presentSnackBar(snackBar)
        }
    }
    
    private func configSecureDataFor(_ flows: [ModularSubflow]) {
        flows.forEach {
            configSecureDataFor($0)
        }
    }
    
    private func configSecureDataFor(_ flow: ModularSubflow) {
        flow.processCommandHandler = { [weak self] command in
            self?.processSecureCommand(command)
        }
    }
    
    private func privateLogout() {
        DispatchQueue.main.async { [weak self] in
            self?.output.didPrivateLogout()
        }
    }

    private func configShowWebView(_ flows: [ModularSubflow]) {
        flows.forEach {
            $0.showWebViewHandler = { [weak self] url in
                self?.output.didShowExplorer(url: url)
            }
        }
    }
    
    private func changePin() {
        DispatchQueue.main.async { [weak self] in
            self?.output.didRequestChangePin()
        }
    }
    
    // MARK: SecureData
    
    private func processSecureCommand(_ command: SecureDataCommand) {
        DispatchQueue.main.async { [weak self] in
            if let command = command as? SecureDataRemoveCommand {
                self?.precessRemoveCommand(command)
            } else {
                self?.output.didRequestPin()
                self?.secureCommands.append(command)
            }
        }
    }
    
    func validatePin(pin: String) -> Bool {
        return authFacade.verify(pin: pin)
    }
    
    func precessRemoveCommand(_ command: SecureDataRemoveCommand) {
        do {
            try sensitiveDataService.removeSensitiveData(key: command.key)
            command.completion(.success(""))
        } catch {
            command.completion(.failure(.storageError))
        }
    }
    
    func processAllCommands(pin: String) {
        secureCommands.forEach {
            do {
                if let command = $0 as? SecureDataStoreCommand {
                    try sensitiveDataService.setSensitiveData(pass: pin, key: command.key, data: command.value)
                    command.completion(.success(""))
                } else if let command = $0 as? SecureDataLoadCommand {
                    let value = try sensitiveDataService.obtainSensitiveData(pass: pin, key: command.key)
                    $0.completion(.success(value))
                } else {
                    $0.completion(.failure(.handlerNotSettup))
                }
            } catch {
                $0.completion(.failure(.encryptionError))
            }
        }
        secureCommands = []
    }
    
    func cancellAllCommands() {
        secureCommands.forEach {
            $0.completion(.failure(.userCanceled))
        }
        secureCommands = []
    }
    
    func registerRemoteNotifications() {
        flowNotificationFacade.registerRemoteNotifications()
    }
    
    func updateRemoteNotifications() {
        flowNotificationFacade.update(flows: flows)
    }
    
    func checkForNewFirebaseToken() {
        flowNotificationFacade.updateToken(flows: flows as [Notifiable])
    }
}

extension MainRoutingInteractor: SessionTimeoutDelegate {
    func sessionActivityTimeout() {
        DispatchQueue.main.async { [weak self] in
            self?.output.didExpireSession()
        }
    }
}

extension MainRoutingInteractor: ReachabilityEventDelegate {
    func reachabilityChanged(newConnection: ReachabilityConnection) {
        switch newConnection {
        case .reachable:
            updateRemoteNotifications()
            print("Reachable connection")
            
        case .unreachable:
            print("Unreachable connection")
        }
    }
}

extension MainRoutingInteractor: FirebaseTokenEventDelegate {
    func firebaseTokenDidChange(newToken: String, previousToken: String?) {
        checkForNewFirebaseToken()
    }
}

// MARK: - SnackBarsEventDelegate

extension MainRoutingInteractor: SnackBarsEventDelegate {
    func didPresentSnackBar(_ snackBar: SnackBarPresentable) {
        output.presentSnackBar(snackBar)
    }
}
