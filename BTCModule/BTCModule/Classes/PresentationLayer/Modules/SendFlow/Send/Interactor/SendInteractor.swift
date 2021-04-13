//
//  SendSendInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class SendInteractor {
    weak var output: SendInteractorOutput!
    var settingsConfiguration: BTCSettingsConfiguration!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var authService: BTCAuthService!
    var transferService: BTCTransferService!
    var updateService: BTCUpdateService!
    
    let currency = BTCCurrency.btcCurrency
    let usdCurrency = Currencies.usd
    var lastUpdatedCurrentBalance: Amount?
    var lastUpdatedCurrentBalanceRate: String?
    var lastUpdatedFee: Amount?
    
    let emptyBalanceString = "0"
}

// MARK: - SendInteractorInput

extension SendInteractor: SendInteractorInput {    
    func updateBalanceInfo() {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        updateService.updateWalletBalance(wallet: wallet) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let entity: WalletBalanceEntity?
            switch result {
            case .success(let balance):
                let amount = Amount(value: balance, decimals: strongSelf.currency.decimals)
                strongSelf.lastUpdatedCurrentBalance = amount
                entity = WalletBalanceEntity(
                    balanceWithCurrency: strongSelf.mapAttributedStringForBalance(symbol: strongSelf.currency.symbol,
                                                                                  amount: amount.valueWithDecimals.toFormattedCropNumber())
                )
                
            case .failure:
                entity = self?.obtainInitialBalanceEntity()
            }
            
            if let entity = entity {
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateBalance(entity: entity)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateRate()
            }
        }
        updateService.obtainRate { [weak self] result in
            let failure: Bool
            
            switch result {
            case .success(let model):
                self?.lastUpdatedCurrentBalanceRate = model.rate
                failure = false
                
            case .failure:
                failure = true
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateRate(failed: failure)
            }
        }
    }
    
    func obtainInitialBalanceEntity() -> WalletBalanceEntity {
        guard let wallet = try? authService.getCurrentWallet() else {
            return getEmptyBalanceEntity()
        }
        let balance = updateService.getLocalBalanceFor(wallet: wallet)
        let amount = Amount(value: balance, decimals: currency.decimals)
        lastUpdatedCurrentBalance = amount
        let attributedString = mapAttributedStringForBalance(symbol: currency.symbol,
                                                             amount: amount.valueWithDecimals.toFormattedCropNumber())
        
        return WalletBalanceEntity(balanceWithCurrency: attributedString)
    }
    
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity {
        var balance = emptyBalanceString
        var balanceRate = emptyBalanceString
        
        if let wallet = try? authService.getCurrentWallet() {
            balance = updateService.getLocalBalanceFor(wallet: wallet)
            balanceRate = updateService.getLocalRate()
        }
        
        let amount = Amount(value: balance, decimals: currency.decimals)
        let formattedBalance = BigDecimalNumber(amount.valueWithDecimals).toFormattedCropNumber(multiplier: balanceRate,
                                                                                                precision: usdCurrency.decimals)
        
        return WalletBalanceRateEntity(rate: formattedBalance, symbol: usdCurrency.symbol)
    }
    
    func obtainInitialFeeEntity() -> SendFeeEntity {
        let standartFee = Amount(value: Constants.BTCConstants.BTCStandartFee, decimals: currency.decimals)
        lastUpdatedFee = standartFee
        let entity = SendFeeEntity(fee: standartFee.valueWithDecimals.toLocaleSeparator())
        
        return entity
    }
    
    func updateCurrencyAmount(amount: String) -> SendAmountEntity {
        if let rate = lastUpdatedCurrentBalanceRate, !amount.isEmpty {
            let formattedCurrencyAmount = calculateFormattedCurrencyAmount(amount: amount, rate: rate)
            return SendAmountEntity(amount: .none, currencyAmount: formattedCurrencyAmount)
        }
        return SendAmountEntity(amount: .none, currencyAmount: .none)
    }
    
    func updateAmount(amount: String) -> SendAmountEntity {
        if let rate = lastUpdatedCurrentBalanceRate, !amount.isEmpty {
            let formattedAmount = calculateFormattedAmount(amount: amount, rate: rate)
            return SendAmountEntity(amount: formattedAmount, currencyAmount: .none)
        }
        return SendAmountEntity(amount: .none, currencyAmount: .none)
    }
    
    func calculateCurrencyForAmount(amount: String) -> SendAmountEntity {
        if let rate = lastUpdatedCurrentBalanceRate, !amount.isEmpty,
            isValidFormat(amount: amount, currency: currency) {
            let formattedCurrency = calculateFormattedCurrencyAmount(amount: amount, rate: rate)
            return SendAmountEntity(amount: amount, currencyAmount: formattedCurrency)
        }
        return SendAmountEntity(amount: amount, currencyAmount: .none)
    }
    
    func obtainAllBalance() -> SendAmountEntity {
        if let lastUpdatedCurrentBalance = lastUpdatedCurrentBalance, let lastUpdatedFee = lastUpdatedFee {
            let decimals = BigDecimalNumber(lastUpdatedCurrentBalance.decimals)
            let diffValue = BigDecimalNumber(lastUpdatedCurrentBalance.value)
                .subtract(BigDecimalNumber(lastUpdatedFee.value))
            if diffValue.isLessOrEqual(BigDecimalNumber(0)) {
                return SendAmountEntity(amount: .none, currencyAmount: .none)
            } else {
                let diffWithDecimals = diffValue.powerOfMinusTen(decimals)
                var currencyAmount: String? = nil
                if let rate = lastUpdatedCurrentBalanceRate {
                    currencyAmount = calculateFormattedCurrencyAmount(amount: diffWithDecimals, rate: rate)
                }
                return SendAmountEntity(amount: diffWithDecimals.toLocaleSeparator(), currencyAmount: currencyAmount)
            }
        }
        
        return SendAmountEntity(amount: .none, currencyAmount: .none)
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func countFeeForTransaction(inputs: SendInputs) {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        let amount = Amount(userFrendlyValue: inputs.amount, decimals: currency.decimals)

        transferService.estimate(fromAddress: wallet.address, amount: amount.value) { [weak self] result in
            switch result {
            case .success(let fee):
                DispatchQueue.main.async { [weak self] in
                    let feeAmount = Amount(value: String(fee),
                                           decimals: Constants.BTCConstants.BTCDecimal)
                    self?.lastUpdatedFee = feeAmount
                    let entity = SendFeeEntity(fee: feeAmount.valueWithDecimals.toFormattedCropNumber())
                    self?.output.didUpdateFee(entity: entity)
                }
                
            case .failure:
                print("Transaction fee counting error.")
            }
        }
    }
    
    func sendTransaction(inputs: SendInputs, seed: String) {
        let toAddress = inputs.toAddress
        let amount = Amount(userFrendlyValue: inputs.amount, decimals: currency.decimals)
        
        transferService.send(seed: seed, toAddress: toAddress, amount: amount.value) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.output.didSendTransaction()
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    self?.output.didFailSendingTransaction()
                }
            }
        }
    }
    
    func prepareSeed() {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: wallet)
        let command = SecureDataLoadCommand(key: key) { [weak self] result in
            switch result {
            case .success(let wif):
                DispatchQueue.main.async { [weak self] in
                    self?.output.didGetSeed(seed: wif)
                }
                
            case .failure(let error):
                switch error {
                case .userCanceled:
                    DispatchQueue.main.async { [weak self] in
                        self?.output.didDeclineGettingSeed()
                    }
                    
                default:
                    DispatchQueue.main.async { [weak self] in
                        self?.output.didFailGettingSeed()
                    }
                }
            }
        }
        sensitiveDataActionHandler.processCommand(command)
    }
    
    func isValidAmountFormat(amount: String) -> Bool {
        return isValidFormat(amount: amount, currency: currency)
    }
    
    func isValidCurrencyAmountFormat(amount: String) -> Bool {
        return isValidFormat(amount: amount, currency: usdCurrency)
    }
    
    func validateAmount(amount: String) -> SendErrorEntity? {
        guard (isValidFormat(amount: amount, currency: currency)
            && isValidAmountValue(amount: amount)
            && !amount.isEmpty) == false  else {
                return nil
        }
        let amountError = R.string.localization.sendFlowErrorNoAmount()
        let error = SendErrorEntity(amountError: amountError, feeError: nil, toAddressError: nil)
        return error
    }
    
    func validateCurrencyAmount(currency: String) -> SendErrorEntity? {
        if !isValidFormat(amount: currency, currency: usdCurrency) || currency.isEmpty {
            let amountError = R.string.localization.sendFlowErrorNoAmount()
            return SendErrorEntity(amountError: amountError, feeError: nil, toAddressError: nil)
        }
        if let balanceRate = lastUpdatedCurrentBalanceRate {
            let amount = calculateFormattedAmount(amount: currency, rate: balanceRate)
            return validateAmount(amount: amount)
        }
        return nil
    }
    
    func validateInputs(inputs: SendInputs) -> SendErrorEntity? {
        let amountError = validateAmount(amount: inputs.amount)
        let toAddressError = validateToAddress(address: inputs.toAddress)
        let hasError = amountError != nil || toAddressError != nil
        
        let entity: SendErrorEntity?
        if hasError {
            entity = SendErrorEntity(amountError: amountError?.amountError, feeError: nil, toAddressError: toAddressError?.toAddressError)
        } else {
            entity = nil
        }
        return entity
    }
    
    func validateToAddress(address: String) -> SendErrorEntity? {
        guard (isValidBTCAddress(address) && !isMineBTCAddress(address)) == false else {
            return nil
        }
        let toAddressError = R.string.localization.sendFlowErrorToAccountNotFound()
        let error = SendErrorEntity(amountError: nil, feeError: nil, toAddressError: toAddressError)
        return error
    }
    
    // MARK: Private
    
    private func isValidFormat(amount: String, currency: Currency) -> Bool {
        let decimals = currency.decimals
        var regexPattern: String!
        if decimals == 0 {
            regexPattern = "^([1-9]+\\d*)$|^(0)$|^$"
        } else {
            regexPattern = "^([1-9]+\\d*([.,]\\d{1,\(decimals)})?)$" +
            "|^(0[.,]\\d{1,\(decimals)})$|^(0)$|^([0-9][.,])$|^([1-9]\\d+[.,])$|^$"
        }
        
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return false
        }
        
        let isValid = regex.firstMatch(
            in: amount,
            options: [],
            range: NSRange(location: 0, length: amount.count)
            ) != nil
        
        return isValid
    }
    
    private func updateRate(failed: Bool = false) {
        if failed {
            output.didGetNoRates()
        } else {
            if let balance = lastUpdatedCurrentBalance, let balanceRate = lastUpdatedCurrentBalanceRate {
                let roundedRate = BigDecimalNumber(balance.valueWithDecimals).toFormattedCropNumber(multiplier: balanceRate,
                                                                                                    precision: usdCurrency.decimals)
                output.didUpdateBalanceRate(
                    entity: WalletBalanceRateEntity(rate: roundedRate, symbol: usdCurrency.symbol)
                )
            }
        }
    }
    
    private func calculateFormattedCurrencyAmount(amount: String, rate: String) -> String {
        let rate = BigDecimalNumber(amount).multiply(BigDecimalNumber(rate))
        let lowerValue = BigDecimalNumber(1).powerOfMinusTen(BigDecimalNumber(usdCurrency.decimals))
        if rate.isLess(BigDecimalNumber(lowerValue)) {
            return rate.stringValue(precisionAfterDecimalPoint: 2, rounded: false).toLocaleSeparator()
        }
        let rateWithPrecision = BigDecimalNumber(
            rate.stringValue(precisionAfterDecimalPoint: usdCurrency.decimals, rounded: false)
        )
        let reducedRate = rateWithPrecision.reduceENotation()
        return reducedRate.toLocaleSeparator()
    }
    
    private func calculateFormattedAmount(amount: String, rate: String) -> String {
        let rate = BigDecimalNumber(amount).divide(BigDecimalNumber(rate))
        let rateWithPrecision = BigDecimalNumber(rate.stringValue(precisionAfterDecimalPoint: self.currency.decimals))
        let reducedRate = rateWithPrecision.reduceENotation()
        return reducedRate.toLocaleSeparator()
    }
    
    private func isValidBTCAddress(_ btcAddress: String) -> Bool {
        return transferService.isValidAddress(btcAddress)
    }
    
    private func isMineBTCAddress(_ btcAddress: String) -> Bool {
        guard let wallet = try? authService.getCurrentWallet() else {
            return false
        }
        return wallet.address.lowercased() == btcAddress.lowercased()
    }
    
    private func isValidAmountValue(amount: String) -> Bool {
        guard let lastUpdatedCurrentBalance = lastUpdatedCurrentBalance, let lastUpdatedFee = lastUpdatedFee else {
            return false
        }
        guard BigDecimalNumber(amount).isGreater(BigDecimalNumber(0)) else {
            return false
        }
        
        let actualAmount = BigDecimalNumber(lastUpdatedCurrentBalance.value)
            .subtract(BigDecimalNumber(lastUpdatedFee.value))
        let actualAmountWithDecimals = actualAmount.powerOfMinusTen(BigDecimalNumber(lastUpdatedCurrentBalance.decimals))
        if BigDecimalNumber(actualAmountWithDecimals).isLess(BigDecimalNumber(amount)) {
            return false
        } else {
            return true
        }
    }
    
    private func mapAttributedStringForBalance(symbol: String, amount: String) -> NSAttributedString {
        let balance = NSMutableAttributedString(
            string: amount,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 14) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .blue
            ]
        )
        
        let currency = NSMutableAttributedString(
            string: " " + symbol,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 14) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .blue
            ]
        )
        
        balance.append(currency)
        return balance
    }
    
    private func getEmptyBalanceEntity() -> WalletBalanceEntity {
        let totalBalance = emptyBalanceString
        return WalletBalanceEntity(
            balanceWithCurrency: mapAttributedStringForBalance(symbol: currency.symbol,
                                                               amount: totalBalance.toFormattedCropNumber())
        )
    }
}

extension SendInteractor: BTCUpdateEventDelegate {
    func didUpdateBalance(wallet: BTCWallet) {
        updateBalanceInfo()
    }
}
