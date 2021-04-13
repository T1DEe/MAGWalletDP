//
//  AuthImportBrainkeyAuthImportBrainkeyProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AuthImportBrainkeyViewInput: class, Presentable {
    func setupInitialState()
    
    func startLoading()
    func endLoading()
    
    func makeTryAction()
}

protocol AuthImportBrainkeyViewOutput {
    func viewIsReady()
    
    func actionCheckBrainkey(seed: String?) -> Bool
    func actionImport(seed: String)
    func actionBack()
}

protocol AuthImportBrainkeyModuleInput: class {
	var viewController: UIViewController { get }
	var output: AuthImportBrainkeyModuleOutput? { get set }
    
    func presentFrom(_ viewController: UIViewController)
}

protocol AuthImportBrainkeyModuleOutput: class {
}

protocol AuthImportBrainkeyInteractorInput {
    func isValidSeed(seed: String?) -> Bool
    func importAccount(seed: String)
    func saveSeedAndWallet(wallet: LTCWallet, seed: String)
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func comleteAuth()
}

protocol AuthImportBrainkeyInteractorOutput: class {
    func didCreateWallet(wallet: LTCWallet, seed: String)
    func didLoginSuccess()
    func didErrorOccurr(_ error: ButtonSnackBarModel?)
}

protocol AuthImportBrainkeyRouterInput {
    func getButtonSnackBar() -> ButtonSnackBarModuleInput
}
