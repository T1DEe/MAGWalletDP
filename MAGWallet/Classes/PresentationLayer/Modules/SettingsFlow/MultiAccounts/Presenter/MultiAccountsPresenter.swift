//
//  MultiAccountsPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum SnackBarPresentReason {
    case selectAccount(MultiAccountsScreenAccountModel, AccountInfo)
    case deleteAccount(MultiAccountsScreenAccountModel, AccountInfo)
}

class MultiAccountsPresenter {
    weak var view: MultiAccountsViewInput!
    weak var output: MultiAccountsModuleOutput?
    
    var interactor: MultiAccountsInteractorInput!
    var router: MultiAccountsRouterInput!
    var accountsHolders: [AccountInfo] = []

    var presentSnackBarReason: SnackBarPresentReason?
    
    private func setupState() {
        let model = interactor.getScreenModel()
        view.setupInitialState(model: model)
    }
}

// MARK: - MultiAccountsModuleInput

extension MultiAccountsPresenter: MultiAccountsModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - MultiAccountsViewOutput

extension MultiAccountsPresenter: MultiAccountsViewOutput {
    func viewIsReady() {
        interactor.setAccountHolders(accountsHolders)
        interactor.updateModel()
        setupState()
    }

    func actionBack() {
        view.dissmiss()
    }
    
    func actionAddAccount(accountsHolder: AccountInfo) {
        output?.didAddAccount(account: accountsHolder)
    }
    
    func actionSelectAccountAsCurrent(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo) {
        let snackBar = router.getButtonSnackBar()
        let model = ButtonSnackBarModel(isBlocker: true,
                                        isError: false,
                                        title: R.string.localization.accountsScreenSwitchSnackbarTitle(),
                                        message: R.string.localization.accountsScreenSwitchSnackbarMessage(),
                                        leftButtonTitle: R.string.localization.accountsScreenSwitchSnackbarLeftButton(),
                                        rightButtonTitle: R.string.localization.accountsScreenSwitchSnackbarRightButton())
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        presentSnackBarReason = .selectAccount(account, accountsHolder)
        interactor.makeShowSnackBarEvent(snackBar)
    }
    
    func actionDeleteAccount(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo) {
        let snackBar = router.getButtonSnackBar()
        let model = ButtonSnackBarModel(isBlocker: true,
                                        isError: false,
                                        title: R.string.localization.accountsScreenDeleteSnackbarTitle(),
                                        message: R.string.localization.accountsScreenDeleteSnackbarMessage(),
                                        leftButtonTitle: R.string.localization.accountsScreenDeleteSnackbarLeftButton(),
                                        rightButtonTitle: R.string.localization.accountsScreenDeleteSnackbarRightButton())
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        presentSnackBarReason = .deleteAccount(account, accountsHolder)
        interactor.makeShowSnackBarEvent(snackBar)
    }
}

// MARK: - ButtonSnackBarModuleOutput

extension MultiAccountsPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        guard let reason = presentSnackBarReason else {
            return
        }

        switch reason {
        case .selectAccount(let account, let holder):
            interactor.selectAccountAsCurrent(account, accountsHolder: holder)

        case .deleteAccount(let account, let holder):
            interactor.deleteAccount(account, accountsHolder: holder)
        }
        presentSnackBarReason = nil
    }
}

// MARK: - MultiAccountsInteractorOutput

extension MultiAccountsPresenter: MultiAccountsInteractorOutput {
    func modelUpdated() {
        setupState()
    }
    
    func errorHandled(model: ButtonSnackBarModel) {
        let snackBar = router.getButtonSnackBar()
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        interactor.makeShowSnackBarEvent(snackBar)
    }
}
