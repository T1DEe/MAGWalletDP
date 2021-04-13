//
//  WalletWalletPresenter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class WalletPresenter {
    weak var view: WalletViewInput!
    weak var output: WalletModuleOutput?
    
    var interactor: WalletInteractorInput!
    var router: WalletRouterInput!
    var needShowBack: Bool = false
    
    func setupInitialState() {
        let entity = interactor.obtainInitialEntity()
        view.setupState(entity: entity)
        let rate = interactor.obtainInitialBalanceRate()
        view.setupBalanceRate(entity: rate)
        view.setupButtonState(isBackButtonHidden: !needShowBack)
    }
}

// MARK: - WalletModuleInput

extension WalletPresenter: WalletModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func heightDidChanged(height: CGFloat) {
        view.setupState(height: height)
    }
}

// MARK: - WalletViewOutput

extension WalletPresenter: WalletViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        setupInitialState()
    }
    
    func viewIsReadyToShow() {
        interactor.updateBalanceInfo()
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

// MARK: - WalletInteractorOutput

extension WalletPresenter: WalletInteractorOutput {
    func didNewWalletSelected() {
        setupInitialState()
    }
    
    func didUpdateBalance(entity: WalletEntity) {
        view.setupState(entity: entity)
    }
    
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity) {
        view.setupBalanceRate(entity: entity)
    }
}
