//
//  SendPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

enum SelectCurrencyFlowType {
    case none
    case forAmount
    case forFee
}

class SendPresenter {
    weak var view: SendViewInput!
    weak var output: SendModuleOutput?
    
    var interactor: SendInteractorInput!
    var router: SendRouterInput!
    var entity: ScanEntity?
    private var currentAmountCurrency = ETHCurrency.ethCurrency
    private var selectCurrencyFlow: SelectCurrencyFlowType = .none

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
    
    func getInputs() -> (String, Currency, String) {
        let amount = view.obtainAmount()
        let currency = currentAmountCurrency
        let toAddress = view.obtainAccountName().trimmingCharacters(in: .whitespaces)
        let inputs = (amount, currency, toAddress)
        return inputs
    }
    
    func updateWithScan(entity: ScanEntity) {
        if let toAddress = entity.toAddress {
            let entityTo = SendToAddressEntity(toAddress: toAddress)
            view.setupToAddress(entity: entityTo)
        }
        
        if let contractAddress = entity.contractAddress {
            let currencies = interactor.obtainPayCurrency()
            if let findedCurrency = currencies.echoAssetsAndTokens.first(where: { $0.id == contractAddress }) {
                currentAmountCurrency = findedCurrency
                updateCurrencyInView()
                updateRatesInView()
            } else {
                presentSnackBar(title: R.string.localization.sendFlowErrorTokenNotFound(), isError: true)
            }
        } else {
            currentAmountCurrency = ETHCurrency.ethCurrency
            updateCurrencyInView()
            updateRatesInView()
        }
        
        let currency = currentAmountCurrency
        if let amount = entity.amount {
            let entity = interactor.calculateCurrencyForAmount(for: currency, amount: amount)
            view.setupAmount(entity: entity, shouldValidate: true)
            view.setupCurrencyAmount(entity: entity, shouldValidate: true)
            if let entity = interactor.validateAmount(amount: amount, currency: currency) {
                view.setupErrors(entity: entity)
            }
        }
        updateFee()
    }
    
    func updateCurrencyInView() {
        view.setCurrencyForFee(ETHCurrency.ethCurrency)
        view.setCurrencyForAmount(currentAmountCurrency)
    }
    
    func updateRatesInView() {
        let isRatesLoaded = interactor.isRatesLoaded(for: currentAmountCurrency)
        view.changeRatesVisibility(isRatesLoaded)
        if isRatesLoaded {
            let entity = interactor.calculateCurrencyForAmount(for: currentAmountCurrency, amount: view.obtainAmount())
            view.setupAmount(entity: entity, shouldValidate: true)
            view.setupCurrencyAmount(entity: entity, shouldValidate: true)
        }
    }
    
    func updateFee() {
        let inputs = getInputs()
        interactor.countFeeForTransaction(inputs: inputs)
    }
}

// MARK: - SendModuleInput

extension SendPresenter: SendModuleInput {
      var viewController: UIViewController {
        return getViewController()
      }
}

// MARK: - SendViewOutput

extension SendPresenter: SendViewOutput {
    func viewIsReady() {
        if interactor.hasAdditionalToken() {
            view.setupAdditionalTokenInputs()
        }
        let hasToken = interactor.hasAdditionalToken()
        let balance = interactor.obtainInitialBalanceEntity()
        let rate = interactor.obtainInitialBalanceRate()
        let fee = interactor.obtainInitialFeeEntity()
        view.setupBalance(entity: balance, hasToken: hasToken)
        view.setupFee(entity: fee)
        view.setupBalanceRate(entity: rate)
        if hasToken {
            let tokenBalance = interactor.obtainInitialTokenBalanceEntity()
            view.setupTokenBalance(entity: tokenBalance)
        }
        interactor.updateBalanceInfo()
        interactor.updateTokenBalanceInfo()
        updateFee()
        updateCurrencyInView()
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
        let entity = interactor.obtainAllBalance(currency: currentAmountCurrency)
        view.setupAmount(entity: entity, shouldValidate: true)
        view.setupCurrencyAmount(entity: entity, shouldValidate: true)
    }
    
    func actionValidateAmount(amount: String) {
        guard amount.isEmpty == false else {
            return
        }
        let currency = currentAmountCurrency
        if let entity = interactor.validateAmount(amount: amount, currency: currency) {
            view.setupErrors(entity: entity)
        }
    }
    
    func actionValidateCurrencyAmount(amount: String) {
        guard amount.isEmpty == false else {
            return
        }
        let currency = currentAmountCurrency
        if let entity = interactor.validateCurrencyAmount(amount: amount, currency: currency) {
            view.setupErrors(entity: entity)
        }
    }
    
    func actionValidateAmountFormat(amount: String) -> Bool {
        return interactor.isValidAmountFormat(for: currentAmountCurrency, amount: amount)
    }
    
    func actionValidateCurrencyAmountFormat(amount: String) -> Bool {
        return interactor.isValidCurrencyAmountFormat(amount: amount)
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
    
    func actionSelectFeeCurrencies() { }
    
    func actionSelectAmountCurrencies() {
        let currencies = interactor.obtainPayCurrency()
        let selectCurrencyModule = router.getCurrencySnackBar()
        selectCurrencyModule.output = self
        selectCurrencyModule.setCurrencies(currencies)
        selectCurrencyModule.setSelectedCurrency(currentAmountCurrency)
        selectCurrencyFlow = .forAmount
        interactor.presentSnackBar(selectCurrencyModule)
    }
    
    func actionUpdateAmount(amount: String, shouldFieldError: Bool) {
        let amount = interactor.updateAmount(for: currentAmountCurrency, amount: amount)
        print(amount)
        view.setupAmount(entity: amount, shouldValidate: shouldFieldError)
    }
    
    func actionUpdateCurrencyAmount(amount: String, shouldFieldError: Bool) {
        let currencyAmount = interactor.updateCurrencyAmount(for: currentAmountCurrency, amount: amount)
        print(currencyAmount)
        view.setupCurrencyAmount(entity: currencyAmount, shouldValidate: shouldFieldError)
    }
}

extension SendPresenter: SelectCurrencySnackBarModuleOutput {
    func currencySelected(_ currency: Currency) {
        currencySelected(currency, needNotify: true)
    }
    
    func currencySelected(_ currency: Currency, needNotify: Bool) {
        switch selectCurrencyFlow {
        case .forAmount:
            currentAmountCurrency = currency

        default:
            break
        }
        
        selectCurrencyFlow = .none
        updateRatesInView()
        updateCurrencyInView()
        updateFee()
    }
    
    func selectionCanceled() {
        selectCurrencyFlow = .none
        updateCurrencyInView()
        updateRatesInView()
    }
}

extension SendPresenter: ScanModuleOutput {
    func didScanEthQr(entity: ScanEntity) {
        updateWithScan(entity: entity)
    }
    
    func permissionsDenied() { }
}
// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    func didUpdateBalance(entity: WalletBalanceEntity) {
        view.setupBalance(entity: entity, hasToken: interactor.hasAdditionalToken())
    }
    
    func didUpdateTokenBalance(entity: WalletTokenBalanceEntity) {
        if interactor.hasAdditionalToken() {
            view.setupTokenBalance(entity: entity)
        }
    }
    
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity) {
        view.setupBalanceRate(entity: entity)
    }
    
    func didDeclineGettingSeed() {
        view.hideLoader()
    }
    
    func didFailGettingSeed() {
        view.hideLoader()
        presentSnackBar(title: R.string.localization.sendFlowErrorTransactionSend(), isError: true)
    }
    
    func didValidateToAddress(address: String, errorEntity: SendErrorEntity) {
        let currentToAddress = view.obtainAccountName()
        if currentToAddress == address {
            view.setupErrors(entity: errorEntity)
        }
    }
    
    func didGetSeed(seed: String) {
        view.showLoader()
        let inputs = getInputs()
        interactor.sendTransaction(inputs: inputs, seed: seed)
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
    
    func didGetNoRates(for currency: Currency) {
        if currency == currentAmountCurrency {
            view.changeRatesVisibility(false)
        }
    }
}
