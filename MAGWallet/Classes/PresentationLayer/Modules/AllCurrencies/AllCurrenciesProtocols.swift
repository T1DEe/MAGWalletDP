//
//  AllCurrenciesAllCurrenciesProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AllCurrenciesViewInput: class, Presentable {
    func setupInitialState(models: [AllCurrenciesScreenModel])
    func updateConrols()
}

protocol AllCurrenciesViewOutput {
    func viewIsReady()
    func viewIsReadyToShow()
    func actionSettings()
    func actionSelectAccount(account: AccountInfo)
}

protocol AllCurrenciesModuleInput: class {
	var viewController: UIViewController { get }
	var output: AllCurrenciesModuleOutput? { get set }
    var accounts: [AccountInfo] { get set }
    var networks: [NetworkConfigurable] { get set }
}

protocol AllCurrenciesModuleOutput: class {
    func didSelectAccount(account: AccountInfo)
    func didAddAccount(account: AccountInfo)
    func didRequestChangePin()
    func didGlobalLogout()
}

protocol AllCurrenciesInteractorInput {
    func getModels(accounts: [AccountInfo]) -> [AllCurrenciesScreenModel]
}

protocol AllCurrenciesInteractorOutput: class {
    func didUpdateAccount()
}

protocol AllCurrenciesRouterInput {
    func presentSettings(output: SettingsModuleOutput, accountsHolders: [AccountInfo], networks: [NetworkConfigurable])
}
