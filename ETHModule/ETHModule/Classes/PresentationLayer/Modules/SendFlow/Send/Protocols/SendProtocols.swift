//
//  SendProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

typealias SendInputs = (amount: String, currency: Currency, toAddress: String)

protocol SendViewInput: class, Presentable {
    func setupFee(entity: SendFeeEntity)
    func setupAmount(entity: SendAmountEntity, shouldValidate: Bool)
    func setupCurrencyAmount(entity: SendAmountEntity, shouldValidate: Bool)
    func setupToAddress(entity: SendToAddressEntity)
    func setupErrors(entity: SendErrorEntity)
    func obtainAmount() -> String
    func obtainAccountName() -> String
    func hideKeyboard()
    func showLoader()
    func hideLoader()
    func changeRatesVisibility(_ visible: Bool)
    func setupAdditionalTokenInputs()
    func setCurrencyForAmount(_ currency: Currency)
    func setCurrencyForFee(_ currency: Currency)
    func setupBalance(entity: WalletBalanceEntity, hasToken: Bool)
    func setupTokenBalance(entity: WalletTokenBalanceEntity)
    func setupBalanceRate(entity: WalletBalanceRateEntity)
}

protocol SendViewOutput {
    func viewIsReady()
    func actionBack()
    func actionQRCode()
    func actionSend()
    func actionSendAll()
    func actionSelectFeeCurrencies()
    func actionSelectAmountCurrencies()
    func actionValidateAmount(amount: String)
    func actionValidateCurrencyAmount(amount: String)
    func actionValidateAmountFormat(amount: String) -> Bool
    func actionValidateCurrencyAmountFormat(amount: String) -> Bool
    func actionValidateToAddress(toAddress: String)
    func actionUpdateFee()
    func actionUpdateCurrencyAmount(amount: String, shouldFieldError: Bool)
    func actionUpdateAmount(amount: String, shouldFieldError: Bool)
}

protocol SendModuleInput: SubflowModule {
    var viewController: UIViewController { get }
    var output: SendModuleOutput? { get set }
    var entity: ScanEntity? { get set }
}

protocol SendModuleOutput: class {
    func didSelectBack()
}

protocol SendInteractorInput {
    func updateBalanceInfo()
    func updateTokenBalanceInfo()
    func obtainInitialFeeEntity() -> SendFeeEntity
    func obtainInitialBalanceEntity() -> WalletBalanceEntity
    func obtainInitialTokenBalanceEntity() -> WalletTokenBalanceEntity
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity
    func obtainAllBalance(currency: Currency) -> SendAmountEntity
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func countFeeForTransaction(inputs: SendInputs)
    func sendTransaction(inputs: SendInputs, seed: String)
    func prepareSeed()
    func hasAdditionalToken() -> Bool
    func obtainPayCurrency() -> PayCurrenciesModel
    func updateAmount(for currency: Currency, amount: String) -> SendAmountEntity
    func updateCurrencyAmount(for currency: Currency, amount: String) -> SendAmountEntity
    func calculateCurrencyForAmount(for currency: Currency, amount: String) -> SendAmountEntity
    func isRatesLoaded(for currency: Currency) -> Bool
    
    //validation
    func isValidAmountFormat(for currency: Currency, amount: String) -> Bool
    func isValidCurrencyAmountFormat(amount: String) -> Bool
    func validateAmount(amount: String, currency: Currency) -> SendErrorEntity? //validate amount and show error exept empty string
    func validateCurrencyAmount(amount: String, currency: Currency) -> SendErrorEntity? //validate amount and show error exept empty string
    func validateInputs(inputs: SendInputs) -> SendErrorEntity? //validate amount and address with erro
    func validateToAddress(address: String) -> SendErrorEntity? //validate address exept empty string
}

protocol SendInteractorOutput: class {
    func didGetSeed(seed: String)
    func didFailGettingSeed()
    func didDeclineGettingSeed()
    func didUpdateFee(entity: SendFeeEntity)
    func didSendTransaction()
    func didFailSendingTransaction()
    func didUpdateBalance(entity: WalletBalanceEntity)
    func didUpdateTokenBalance(entity: WalletTokenBalanceEntity)
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity)
    func didGetNoRates(for currency: Currency)
}

protocol SendRouterInput {
    func presentScan(output: ScanModuleOutput)
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
    func getCurrencySnackBar() -> SelectCurrencySnackBarModuleInput
}
