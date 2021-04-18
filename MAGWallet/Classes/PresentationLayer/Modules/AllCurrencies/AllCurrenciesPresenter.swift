//
//  AllCurrenciesAllCurrenciesPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AllCurrenciesPresenter {
    weak var view: AllCurrenciesViewInput!
    weak var output: AllCurrenciesModuleOutput?
    
    var interactor: AllCurrenciesInteractorInput!
    var router: AllCurrenciesRouterInput!
    var accounts: [AccountInfo] = []
    var networks: [NetworkConfigurable] = []
}

// MARK: - AllCurrenciesModuleInput

extension AllCurrenciesPresenter: AllCurrenciesModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - AllCurrenciesViewOutput

extension AllCurrenciesPresenter: AllCurrenciesViewOutput {
    func viewIsReady() {}
    
    func viewIsReadyToShow() {
        let models = interactor.getModels(accounts: accounts)
        view.setupInitialState(models: models)
    }
    
    func actionSelectAccount(account: AccountInfo) {
        output?.didSelectAccount(account: account)
    }
    
    func actionSettings() {
        router.presentSettings(output: self, accountsHolders: accounts, networks: networks)
    }
}

extension AllCurrenciesPresenter: SettingsModuleOutput {
    func didLogoutAction() {
        output?.didGlobalLogout()
    }
    
    func didChangePinAction() {
        output?.didRequestChangePin()
    }
    
    func didAddAccount(account: AccountInfo) {
        output?.didAddAccount(account: account)
    }
}

// MARK: - AllCurrenciesInteractorOutput

extension AllCurrenciesPresenter: AllCurrenciesInteractorOutput {
    func didUpdateAccount() {
        view.updateConrols()
    }
}
