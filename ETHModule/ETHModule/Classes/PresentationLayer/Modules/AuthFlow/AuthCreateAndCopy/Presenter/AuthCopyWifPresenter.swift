//
//  AuthCopyWifAuthCreateAndCopyPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AuthCreateAndCopyPresenter {
    weak var view: AuthCreateAndCopyViewInput!
    weak var output: AuthCreateAndCopyModuleOutput?
    
    var interactor: AuthCreateAndCopyInteractorInput!
    var router: AuthCreateAndCopyRouterInput!
    var wallet: ETHWallet?
    var seed: String?
}

// MARK: - AuthCreateAndCopyModuleInput

extension AuthCreateAndCopyPresenter: AuthCreateAndCopyModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - AuthCreateAndCopyViewOutput

extension AuthCreateAndCopyPresenter: AuthCreateAndCopyViewOutput {
    func viewIsReady() {
        let wallet = interactor.createRandomWallet()
        self.wallet = wallet?.wallet
        seed = wallet?.seed
        view.setupInitialState(seed: seed ?? "")
    }
    
    func actionBack() {
        view.dissmiss()
    }
    
    func actionCopy() {
        UIPasteboard.general.string = seed
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: false,
                                           title: R.string.localization.authCopyCopyMessage(),
                                           buttonTitle: R.string.localization.errorOkButtonTitle())
        snackBar.setButtonSnackBarModel(model)
        
        interactor.presentSnackBar(snackBar)
    }
    
    func actionContinue() {
        guard let wallet = wallet, let seed = seed else {
            return
        }
        interactor.saveBrainkey(wallet: wallet, seed: seed)
    }
}

// MARK: - AuthCreateAndCopyInteractorOutput

extension AuthCreateAndCopyPresenter: AuthCreateAndCopyInteractorOutput {
    func didBrainKeySave() {
        guard let wallet = wallet else {
            return
        }
        interactor.saveWallet(wallet: wallet)
        interactor.subscribeToNotificationsIfNeeded(wallet: wallet)
        interactor.comleteAuth()
    }
    
    func didFailSaveBrainkey(_ error: ButtonSnackBarModel?) {
        guard let error = error else {
            return
        }
        
        let snackBar = router.getButtonSnackBar()
        snackBar.output = self
        snackBar.setButtonSnackBarModel(error)
        interactor.presentSnackBar(snackBar)
    }
    
    func didFailCreateWallet(_ error: ButtonSnackBarModel?) {
        guard let error = error else {
            return
        }
        
        let snackBar = router.getButtonSnackBar()
        snackBar.output = self
        snackBar.setButtonSnackBarModel(error)
        interactor.presentSnackBar(snackBar)
    }
}

extension AuthCreateAndCopyPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        actionContinue()
    }
}
