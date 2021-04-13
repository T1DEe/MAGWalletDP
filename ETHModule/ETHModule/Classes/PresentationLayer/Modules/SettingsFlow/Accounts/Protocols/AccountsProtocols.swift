//
//  AccountsAccountsProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AccountsViewInput: class, Presentable {
    func setupInitialState(model: AccountsScreenModel)
}

protocol AccountsViewOutput {
    func viewIsReady()
    func actionCancel()
    func actionAddAccount()
    func actionSelectAccountAsCurrent(_ account: AccountsScreenAccountModel)
    func actionDeleteAccount(_ account: AccountsScreenAccountModel)
}

protocol AccountsModuleInput: class {
	var viewController: UIViewController { get }
	var output: AccountsModuleOutput? { get set }
}

protocol AccountsModuleOutput: class {
    func actionAddAccount()
    func actionLogout()
}

protocol AccountsInteractorInput {
    func getScreenModel() -> AccountsScreenModel
    func updateModel()
    
    func selectAccountAsCurrent(_ account: AccountsScreenAccountModel)
    func deleteAccount(_ account: AccountsScreenAccountModel)
    func unsubscribeNotifications(_ wallet: ETHWallet)
    
    func makeShowSnackBarEvent(_ snackBar: SnackBarPresentable)
}

protocol AccountsInteractorOutput: class {
    func modelUpdated()
    func didLogout()
    func errorHandled(model: ButtonSnackBarModel)
}

protocol AccountsRouterInput {
    func getButtonSnackBar() -> ButtonSnackBarModuleInput
}
