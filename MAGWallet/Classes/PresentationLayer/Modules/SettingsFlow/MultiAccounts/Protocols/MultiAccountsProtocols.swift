//
//  MultiAccountsMultiAccountsProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol MultiAccountsViewInput: class, Presentable {
    func setupInitialState(model: MultiAccountsScreenModel)
}

protocol MultiAccountsViewOutput {
    func viewIsReady()
    func actionBack()
    func actionAddAccount(accountsHolder: AccountInfo)
    func actionSelectAccountAsCurrent(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo)
    func actionDeleteAccount(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo)
}

protocol MultiAccountsModuleInput: class {
	var viewController: UIViewController { get }
	var output: MultiAccountsModuleOutput? { get set }
    var accountsHolders: [AccountInfo] { get set }
}

protocol MultiAccountsModuleOutput: class {
    func didAddAccount(account: AccountInfo)
}

protocol MultiAccountsInteractorInput {
    func setAccountHolders(_ accountsHolders: [AccountInfo])
    
    func getScreenModel() -> MultiAccountsScreenModel
    func updateModel()
    
    func selectAccountAsCurrent(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo)
    func deleteAccount(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo)
    
    func makeShowSnackBarEvent(_ snackBar: SnackBarPresentable)
}

protocol MultiAccountsInteractorOutput: class {
    func modelUpdated()
    func errorHandled(model: ButtonSnackBarModel)
}

protocol MultiAccountsRouterInput {
    func getButtonSnackBar() -> ButtonSnackBarModuleInput
}
