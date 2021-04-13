//
//  SendSendPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

class SendPresenter {
    weak var view: SendViewInput!
    weak var output: SendModuleOutput?
    
    var interactor: SendInteractorInput!
    var router: SendRouterInput!
    var entity: ScanEntity?
    private var currentAmountCurrency = BTCCurrency.btcCurrency
    
    private weak var navController: UIViewController?
    
    func getViewController() -> UIViewController {
        if let navController = navController {
            return navController
        } else {
            let controller = view.viewController.wrapToNavigationController(BaseNavigationController())
            navController = controller
            return controller
        }
    }
    
    func presentSnackBar(title: String, isError: Bool) {
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: false,
                                           title: title,
                                           buttonTitle: R.string.localization.errorOkButtonTitle(),
                                           isError: isError)
        snackBar.setButtonSnackBarModel(model)
        interactor.presentSnackBar(snackBar)
    }
    
    func getInputs() -> SendInputs {
        let amount = view.obtainAmount()
        let toAddress = view.obtainAccountName().trimmingCharacters(in: .whitespaces)
        let inputs = (amount, toAddress)
        return inputs
    }
    
    func updateWithScan(entity: ScanEntity) {
        if let toAddress = entity.toAddress {
            let entityTo = SendToAddressEntity(toAddress: toAddress)
            view.setupToAddress(entity: entityTo)
        }
        if let amount = entity.amount {
            let entity = interactor.calculateCurrencyForAmount(amount: amount)
            view.setupAmount(entity: entity, shouldValidate: true)
            view.setupCurrencyAmount(entity: entity, shouldValidate: true)
            _ = interactor.validateAmount(amount: amount)
        }
        updateFee()
    }
    
    func updateCurrencyInView() {
        view.setCurrencyForFields(currentAmountCurrency)
    }
    
    func updateFee() {
        let inputs = getInputs()
        interactor.countFeeForTransaction(inputs: inputs)
    }
}

// MARK: - SendModuleInput

extension SendPresenter: SendModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - SendViewOutput

extension SendPresenter: SendViewOutput {
    func viewIsReady() {
        updateCurrencyInView()
        
        let balance = interactor.obtainInitialBalanceEntity()
        let rate = interactor.obtainInitialBalanceRate()
        let fee = interactor.obtainInitialFeeEntity()
        
        view.setupBalance(entity: balance)
        view.setupBalanceRate(entity: rate)
        view.setupFee(entity: fee)
        
        interactor.updateBalanceInfo()
        //updateFee()
        if let entity = entity {
            updateWithScan(entity: entity)
        }
    }
    
    func actionBack() {
        output?.didSelectBack()
    }
    
    func actionQRCode() {
        router.presentScan(output: self)
    }
    
    func actionSend() {
        let inputs = getInputs()
        
        if let entity = interactor.validateInputs(inputs: inputs) {
            view.setupErrors(entity: entity)
            return
        }
        view.hideKeyboard()
        view.showLoader()
        interactor.prepareSeed()
    }
    
    func actionSendAll() {
        let entity = interactor.obtainAllBalance()
        view.setupAmount(entity: entity, shouldValidate: true)
        view.setupCurrencyAmount(entity: entity, shouldValidate: true)
    }
    
    func actionValidateAmount(amount: String, showFieldError: Bool) -> Bool {
        guard amount.isEmpty == false else {
            return false
        }
        if let entity = interactor.validateAmount(amount: amount) {
            if showFieldError {
                view.setupErrors(entity: entity)
            }
            
            return false
        }
        
        return true
    }
    
    func actionValidateCurrencyAmount(currency: String, showFieldError: Bool) -> Bool {
        guard currency.isEmpty == false else {
            return false
        }
        if let entity = interactor.validateCurrencyAmount(currency: currency) {
            if showFieldError {
                view.setupErrors(entity: entity)
            }
            
            return false
        }
        
        return true
    }
    
    func actionValidateAmountFormat(amount: String) -> Bool {
        let isValid = interactor.isValidAmountFormat(amount: amount)
        return isValid
    }
    
    func actionValidateCurrencyAmountFormat(amount: String) -> Bool {
        let isValid = interactor.isValidCurrencyAmountFormat(amount: amount)
        return isValid
    }
    
    func actionValidateToAddress(toAddress: String) {
        guard toAddress.isEmpty == false else {
            return
        }
        if let entity = interactor.validateToAddress(address: toAddress.trimmingCharacters(in: .whitespaces)) {
            view.setupErrors(entity: entity)
        }
    }
    
    func actionUpdateFee() {
        updateFee()
    }
    
    func actionUpdateCurrencyAmount(amount: String) {
        let currencyAmount = interactor.updateCurrencyAmount(amount: amount)
        view.setupCurrencyAmount(entity: currencyAmount, shouldValidate: false)
    }
    
    func actionUpdateAmount(amount: String) {
        let amount = interactor.updateAmount(amount: amount)
        view.setupAmount(entity: amount, shouldValidate: false)
    }
}

extension SendPresenter: ScanModuleOutput {
    func didScanBtcQr(entity: ScanEntity) {
        updateWithScan(entity: entity)
    }
    
    func permissionsDenied() { }
}

// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    func didUpdateBalance(entity: WalletBalanceEntity) {
        view.setupBalance(entity: entity)
    }
    
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity) {
        view.setupBalanceRate(entity: entity)
    }
    
    func didGetSeed(seed: String) {
        view.showLoader()
        let inputs = getInputs()
        interactor.sendTransaction(inputs: inputs, seed: seed)
    }
    
    func didFailGettingSeed() {
        view.hideLoader()
        presentSnackBar(title: R.string.localization.sendFlowErrorTransactionSend(), isError: true)
    }
    
    func didDeclineGettingSeed() {
        view.hideLoader()
    }
    
    func didValidateToAddress(address: String, errorEntity: SendErrorEntity) {
        let currentToAddress = view.obtainAccountName()
        if currentToAddress == address {
            view.setupErrors(entity: errorEntity)
        }
    }
    
    func didValidateAmount(amount: String, currency: Currency, errorEntity: SendErrorEntity) {
        view.setupErrors(entity: errorEntity)
    }
    
    func didUpdateFee(entity: SendFeeEntity) {
        view.setupFee(entity: entity)
    }
    
    func didSendTransaction() {
        view.hideLoader()
        presentSnackBar(title: R.string.localization.sendFlowSuccessTransactionSend(), isError: false)
        interactor.updateBalanceInfo()
    }
    
    func didFailSendingTransaction() {
        view.hideLoader()
        presentSnackBar(title: R.string.localization.sendFlowErrorTransactionSend(), isError: true)
    }
    
    func didGetNoRates() {
        view.hideAllRates()
    }
}
