//
//  SendSendProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

typealias SendInputs = (amount: String, toAddress: String)

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
    func hideAllRates()
    func setupBalance(entity: WalletBalanceEntity)
    func setCurrencyForFields(_ currency: Currency)
    func setupBalanceRate(entity: WalletBalanceRateEntity)
}

protocol SendViewOutput {
    func viewIsReady()
    func actionBack()
    func actionQRCode()
    func actionSend()
    func actionSendAll()
    @discardableResult
    func actionValidateAmount(amount: String, showFieldError: Bool) -> Bool
    @discardableResult
    func actionValidateCurrencyAmount(currency: String, showFieldError: Bool) -> Bool
    @discardableResult
    func actionValidateAmountFormat(amount: String) -> Bool
    func actionValidateCurrencyAmountFormat(amount: String) -> Bool
    func actionValidateToAddress(toAddress: String)
    func actionUpdateFee()
    func actionUpdateCurrencyAmount(amount: String)
    func actionUpdateAmount(amount: String)
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
    func obtainInitialFeeEntity() -> SendFeeEntity
    func obtainInitialBalanceEntity() -> WalletBalanceEntity
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity
    func obtainAllBalance() -> SendAmountEntity
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func countFeeForTransaction(inputs: SendInputs)
    func sendTransaction(inputs: SendInputs, seed: String)
    func prepareSeed()
    func updateAmount(amount: String) -> SendAmountEntity
    func updateCurrencyAmount(amount: String) -> SendAmountEntity
    func calculateCurrencyForAmount(amount: String) -> SendAmountEntity
    
    //validation
    func isValidAmountFormat(amount: String) -> Bool
    func isValidCurrencyAmountFormat(amount: String) -> Bool
    func validateAmount(amount: String) -> SendErrorEntity? //validate amount and show error exept empty string
    func validateCurrencyAmount(currency: String) -> SendErrorEntity? //validate currency and show error
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
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity)
    func didGetNoRates()
}

protocol SendRouterInput {
    func presentScan(output: ScanModuleOutput)
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
}
