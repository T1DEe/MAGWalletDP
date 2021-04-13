//
//  WalletWithTokenWalletWithTokenPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class WalletWithTokenPresenter {
    weak var view: WalletWithTokenViewInput!
    weak var output: WalletModuleOutput?
    
    var interactor: WalletWithTokenInteractorInput!
    var router: WalletWithTokenRouterInput!
    var needShowBack: Bool = false
    
    func setupInitialState() {
        let address = interactor.obtainAddressEntity()
        view.setupAddress(entity: address)
        let balance = interactor.obtainInitialBalanceEntity()
        view.setupBalance(entity: balance)
        let tokenBalance = interactor.obtainInitialTokenBalanceEntity()
        view.setupTokenBalance(entity: tokenBalance)
        let balanceRate = interactor.obtainInitialBalanceRate()
        view.setupBalanceRate(entity: balanceRate)
        view.setupButtonState(isBackButtonHidden: !needShowBack)
    }
}

// MARK: - WalletWithTokenModuleInput

extension WalletWithTokenPresenter: WalletModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func heightDidChanged(height: CGFloat) {
        view.setupState(height: height)
    }
}

// MARK: - WalletWithTokenViewOutput

extension WalletWithTokenPresenter: WalletWithTokenViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        setupInitialState()
    }
    
    func viewIsReadyToShow() {
        interactor.updateBalanceInfo()
        interactor.updateTokenBalanceInfo()
    }
    
    func actionSettings() {
        output?.didSelectSettings()
    }
    
    func actionCopy(text: String) {
        UIPasteboard.general.string = text
        
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: false,
                                           title: R.string.localization.authCopyCopyMessage(),
                                           buttonTitle: R.string.localization.errorOkButtonTitle())
        snackBar.setButtonSnackBarModel(model)
        
        interactor.presentSnackBar(snackBar)
    }
    
    func actionQRcode() {
        output?.didSelectQRCode()
    }

    func actionBack() {
        output?.didSelectBack()
    }
}

// MARK: - WalletWithTokenInteractorOutput

extension WalletWithTokenPresenter: WalletWithTokenInteractorOutput {
    func didNewWalletSelected() {
        setupInitialState()
    }
    
    func didUpdateBalance(entity: WalletBalanceEntity) {
        view.setupBalance(entity: entity)
    }
    
    func didUpdateTokenBalance(entity: WalletTokenBalanceEntity) {
        view.setupTokenBalance(entity: entity)
    }
    
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity) {
        view.setupBalanceRate(entity: entity)
    }
}
