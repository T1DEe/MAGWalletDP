//
//  ApplicationModuleApplicationModulePresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ApplicationModulePresenter {
    weak var output: ApplicationModuleModuleOutput?
    
    var interactor: ApplicationModuleInteractorInput! {
        didSet {
            interactor.bindToEvents()
        }
    }
    var router: ApplicationModuleRouterInput!
    
    var didEndFlow: ((FlowType, FlowEndReason) -> Void)?
    var didSelectFlow: ((FlowType) -> Void)?
    var currentFlow: FlowType = .auth(needShowBack: false)
    var didFinishAllFlows: (() -> Void)?

    // MARK: SnackBarsPresent
    var presentHandler: SnackBarsPresentHandler?
    var changePinHandler: ChangePinHandler?
    var showWebViewHandler: ShowWebViewHandler?

    // MARK: SecureData
    var processCommandHandler: SecureDataProcessCommandHandler?
}

// MARK: - ApplicationModuleModuleInput

extension ApplicationModulePresenter: ApplicationModuleModuleInput {
    func getFlow(type: FlowType) -> SubflowModule {
        currentFlow = type
        return router.getFlow(type: type, output: self)
    }
    
    func finishFlow() { }
    
    func clear() {
        interactor.clearAssembler()
    }
}

extension ApplicationModulePresenter: SettingConfiguratable {
    func obtainConfiguration() -> SettingsConfiguration {
        return interactor.obtainConfiguration()
    }
}

extension ApplicationModulePresenter: AccountInfo {
    func getAccountsTitle() -> String {
        return R.string.localization.accountsScreenSubtitle()
    }
    
    func hasAccounts() -> Bool {
        return interactor.hasWallets()
    }
    
    func obtainCurrentAccount() throws -> String {
        return try interactor.obtainCurrentWallet()
    }
    
    func obtainAccounts() throws -> [String] {
        return try interactor.obtainWallets()
    }
    
    func selectAccount(_ account: String) throws {
        try interactor.selectWallet(account)
    }
    
    func deleteAccount(_ account: String) throws {
        try interactor.deleteWallet(account)
    }
    
    func obtainWalletIcon() -> UIImage {
        return interactor.obtainWalletIcon()
    }
    
    func obtainWalletName() -> String {
        return interactor.obtainWalletName()
    }
    
    func obtainWalletCurrency() -> String {
        return interactor.obtainWalletCurrency()
    }
    
    func obtainTokenCurrency() throws -> String {
        return try interactor.obtainTokenCurrency()
    }
    
    func obtainTokenName() throws -> String {
        return try interactor.obtainTokenName()
    }
    
    func obtainCurrentWalletBalance(completion: @escaping AccountInfoCompletionHandler<String>) {
        interactor.obtainCurrentWalletBalance(completion: completion)
    }
    
    func obtainCurrentTokenBalance(completion: @escaping AccountInfoCompletionHandler<String>) {
        interactor.obtainCurrentTokenBalance(completion: completion)
    }
    
    func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>) {
        interactor.obtainBalances(completion: completion)
    }
    
    func obtainTokenBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>) {
        interactor.obtainTokenBalances(completion: completion)
    }
    
    func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>) {
        interactor.obtainRate(completion: completion)
    }
    
    func obtainTokenRate(completion: @escaping AccountInfoCompletionHandler<String>) {
        interactor.obtainTokenRate(completion: completion)
    }
}

extension ApplicationModulePresenter: ApplicationModulesOutputs {
    func completeAuthFlow() {
        didEndFlow?(currentFlow, .completed)
    }
    
    func cancelAuthFlow(autoCanceled: Bool) {
        didEndFlow?(currentFlow, .canceled(needDismiss: !autoCanceled))
    }
    
    func didSelectAddAccount() {
        didSelectFlow?(.auth(needShowBack: true))
    }
    
    func didSelectSend() {
        didSelectFlow?(.send(nil))
    }
    
    func didSelectBack() {
        didEndFlow?(currentFlow, .canceled(needDismiss: true))
    }
    
    func didSelectSettings() {
        didSelectFlow?(.settings)
    }
    
    func processSesitiveComand(comand: SecureDataCommand) {
        processCommandHandler?(comand)
    }
    
    func didLogoutAction() {
        didFinishAllFlows?()
    }
    
    func didChangePinAction() {
        changePinHandler?()
    }

    func didScan(scanEntity: ScanEntity) {
        didSelectFlow?(.send(scanEntity))
    }
    
    func didGetNoWallets() {
        didEndFlow?(currentFlow, .needAuth)
    }

    func didSelectExplorer(url: URL) {
        showWebViewHandler?(url)
    }
}

// MARK: - ApplicationModuleInteractorOutput

extension ApplicationModulePresenter: ApplicationModuleInteractorOutput {
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        presentHandler?(snackBar)
    }
    
    func processSensitiveDataCommand(_ command: SecureDataCommand) {
        processCommandHandler?(command)
    }
}

extension ApplicationModulePresenter: NetworkConfigurable {
    func changeNetwork(network: Network, useOnlyDefaultNetwork: Bool) {
        interactor.changeNetwork(network: network, useDefault: useOnlyDefaultNetwork)
    }
    
    func changeNetwork(identifiableNetwork: IdentifiableNetwork) {
        interactor.changeNetwork(network: identifiableNetwork)
    }
    
    func getNetworkGroupTitle() -> String {
        return R.string.localization.networkGroupTitle()
    }
    
    func getIdentifiableNetworks() -> [IdentifiableNetwork] {
        return interactor.getIdentifiableNetworks()
    }
    
    func getCurrentNetwork() -> IdentifiableNetwork {
        return interactor.getCurrentNetwork()
    }
}

extension ApplicationModulePresenter: Notifiable {
    func subscribeAll(completion: @escaping NotifiableCompletionHandler<Void>) {
        interactor.subscribeToPushNotifications(completion: completion)
    }
    
    func unsubscribeAll(clearPossibleAddresses: Bool, completion: @escaping NotifiableCompletionHandler<Void>) {
        interactor.unsubscribePushNotifications(clearPossibleAddresses: clearPossibleAddresses, completion: completion)
    }
    
    func updateAll(completion: @escaping NotifiableCompletionHandler<Void>) {
        interactor.updatePushNotification(completion: completion)
    }
    
    func subscribeAddress(address: String, completion: @escaping NotifiableCompletionHandler<Void>) {
        interactor.subscribeAccount(name: address, completion: completion)
    }
    
    func unsubscribeAddress(address: String, completion: @escaping NotifiableCompletionHandler<Void>) {
        interactor.unsubscribeAccount(name: address, completion: completion)
    }
}
