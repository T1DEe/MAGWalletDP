//
//  ApplicationModuleProtocols.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

public protocol ApplicationModuleModuleInput: ModularSubflow {
    var output: ApplicationModuleModuleOutput? { get set }
}

public protocol ApplicationModuleModuleOutput: class {
}

protocol ApplicationModuleInteractorInput {
    func bindToEvents()
    func changeNetwork(network: Network, useDefault: Bool)
    func changeNetwork(network: IdentifiableNetwork)
    func getIdentifiableNetworks() -> [IdentifiableNetwork]
    func getCurrentNetwork() -> IdentifiableNetwork
    
    func hasWallets() -> Bool
    func obtainCurrentWallet() throws -> String
    func obtainWallets() throws -> [String]
    func selectWallet(_ wallet: String) throws
    func deleteWallet(_ wallet: String) throws
    
    func obtainConfiguration() -> SettingsConfiguration
    
    func obtainWalletIcon() -> UIImage
    func obtainWalletName() -> String
    func obtainWalletCurrency() -> String
    
    func obtainCurrentWalletBalance(completion: @escaping AccountInfoCompletionHandler<String>)
    func obtainBalances(completion: @escaping AccountInfoCompletionHandler<[String: String]>)
    
    func obtainRate(completion: @escaping AccountInfoCompletionHandler<String>)
    
    func subscribeToPushNotifications(completion: @escaping NotifiableCompletionHandler<Void>)
    func unsubscribePushNotifications(clearPossibleAddresses: Bool, completion: @escaping NotifiableCompletionHandler<Void>)
    func updatePushNotification(completion: @escaping NotifiableCompletionHandler<Void>)
    func subscribeAccount(name: String, completion: @escaping NotifiableCompletionHandler<Void>)
    func unsubscribeAccount(name: String, completion: @escaping NotifiableCompletionHandler<Void>)
    
    func clearAssembler()
}

protocol ApplicationModuleInteractorOutput: class {
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func processSensitiveDataCommand(_ command: SecureDataCommand)
}

protocol ApplicationModuleRouterInput {
    func getFlow(type: FlowType, output: ApplicationModulesOutputs) -> SubflowModule
}

protocol ApplicationModulesOutputs: AuthRootModuleOutput, MainModuleOutput,
                                    SettingsModuleOutput, SendModuleOutput {
}
