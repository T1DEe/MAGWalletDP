//
//  AuthImportBrainkeyAuthImportBrainkeyPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AuthImportBrainkeyPresenter {
    weak var view: AuthImportBrainkeyViewInput!
    weak var output: AuthImportBrainkeyModuleOutput?
    
    var interactor: AuthImportBrainkeyInteractorInput!
    var router: AuthImportBrainkeyRouterInput!
}

// MARK: - AuthImportBrainkeyModuleInput

extension AuthImportBrainkeyPresenter: AuthImportBrainkeyModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func presentFrom(_ viewController: UIViewController) {
        view.present(fromViewController: viewController)
    }
}

// MARK: - AuthImportBrainkeyViewOutput

extension AuthImportBrainkeyPresenter: AuthImportBrainkeyViewOutput {
    func viewIsReady() {
    }
    
    func actionImport(seed: String) {
        view.startLoading()
        interactor.importAccount(seed: seed)
    }
    
    func actionCheckBrainkey(seed: String?) -> Bool {
        return interactor.isValidSeed(seed: seed)
    }
    
    func actionBack() {
        view.dissmiss()
    }
}

// MARK: - AuthImportBrainkeyInteractorOutput

extension AuthImportBrainkeyPresenter: AuthImportBrainkeyInteractorOutput {
    func didCreateWallet(wallet: ETHWallet, seed: String) {
        interactor.saveSeedAndWallet(wallet: wallet, seed: seed)
    }
    
    func didLoginSuccess() {
        view.endLoading()
        interactor.comleteAuth()
    }
    
    func didErrorOccurr(_ error: ButtonSnackBarModel?) {
        view.endLoading()
        
        guard let error = error else {
            return
        }
        
        let snackBar = router.getButtonSnackBar()
        snackBar.output = self
        snackBar.setButtonSnackBarModel(error)
        interactor.presentSnackBar(snackBar)
    }
}

extension AuthImportBrainkeyPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        view.makeTryAction()
    }
}
