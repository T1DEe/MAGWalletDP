//
//  AccountsAccountsPresenter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum SnackBarPresentReason {
    case selectAccount(AccountsScreenAccountModel)
    case deleteAccount(AccountsScreenAccountModel)
}

class AccountsPresenter {
    weak var view: AccountsViewInput!
    weak var output: AccountsModuleOutput?
    
    var interactor: AccountsInteractorInput!
    var router: AccountsRouterInput!

    var presentSnackBarReason: SnackBarPresentReason?
    
    private func setupState() {
        let model = interactor.getScreenModel()
        view.setupInitialState(model: model)
    }
}

// MARK: - AccountsModuleInput

extension AccountsPresenter: AccountsModuleInput {
      var viewController: UIViewController {
        return view.viewController
      }
}

// MARK: - AccountsViewOutput

extension AccountsPresenter: AccountsViewOutput {
    func viewIsReady() {
        interactor.updateModel()
        setupState()
    }

    func actionCancel() {
        view.dissmiss()
    }

    func actionAddAccount() {
        output?.actionAddAccount()
    }

    func actionSelectAccountAsCurrent(_ account: AccountsScreenAccountModel) {
        let snackBar = router.getButtonSnackBar()
        let model = ButtonSnackBarModel(isBlocker: true,
                                        isError: false,
                                        title: R.string.localization.accountsScreenSwitchSnackbarTitle(),
                                        message: R.string.localization.accountsScreenSwitchSnackbarMessage(),
                                        leftButtonTitle: R.string.localization.accountsScreenSwitchSnackbarLeftButton(),
                                        rightButtonTitle: R.string.localization.accountsScreenSwitchSnackbarRightButton())
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        presentSnackBarReason = .selectAccount(account)
        interactor.makeShowSnackBarEvent(snackBar)
    }

    func actionDeleteAccount(_ account: AccountsScreenAccountModel) {
        let snackBar = router.getButtonSnackBar()
        
        let screenModel = interactor.getScreenModel()
        let title: String
        if screenModel.accounts.count == 1 {
            title = R.string.localization.accountsScreenDeleteLastSnackbarTitle()
        } else {
            title = R.string.localization.accountsScreenDeleteSnackbarTitle()
        }
        
        let model = ButtonSnackBarModel(isBlocker: true,
                                        isError: false,
                                        title: title,
                                        message: R.string.localization.accountsScreenDeleteSnackbarMessage(),
                                        leftButtonTitle: R.string.localization.accountsScreenDeleteSnackbarLeftButton(),
                                        rightButtonTitle: R.string.localization.accountsScreenDeleteSnackbarRightButton())
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        presentSnackBarReason = .deleteAccount(account)
        interactor.makeShowSnackBarEvent(snackBar)
    }
}

// MARK: - ButtonSnackBarModuleOutput

extension AccountsPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        guard let reason = presentSnackBarReason else {
            return
        }

        switch reason {
        case .selectAccount(let account):
            interactor.selectAccountAsCurrent(account)

        case .deleteAccount(let account):
            interactor.deleteAccount(account)
            interactor.unsubscribeNotifications(account.wallet)
        }
        presentSnackBarReason = nil
    }
}

// MARK: - AccountsInteractorOutput

extension AccountsPresenter: AccountsInteractorOutput {
    func modelUpdated() {
        setupState()
    }
    
    func didLogout() {
        output?.actionLogout()
    }
    
    func errorHandled(model: ButtonSnackBarModel) {
        let snackBar = router.getButtonSnackBar()
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        interactor.makeShowSnackBarEvent(snackBar)
    }
}
