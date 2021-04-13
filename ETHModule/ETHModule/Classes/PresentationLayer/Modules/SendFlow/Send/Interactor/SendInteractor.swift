//
//  SendInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BigInt
import SharedFilesModule
import UIKit

class SendInteractor {
    weak var output: SendInteractorOutput!
    var settingsConfiguration: ETHSettingsConfiguration!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var authService: ETHAuthService!
    var transferService: ETHTransferService!
    var updateService: ETHUpdateService!

    var lastUpdatedCurrentBalance: Amount?
    var lastUpdatedTokenBalance: Amount?
    var lastUpdatedCurrentBalanceRate: String?
    var lastUpdatedTokenBalanceRate: String?
    var lastUpdatedFee: Amount?
    
    var rates: WalletTokenBalancesStoreModel!
    let emptyBalanceString = "0"
    let usdCurrency = Currencies.usd
}

// MARK: - SendInteractorInput

extension SendInteractor: SendInteractorInput {
    func updateBalanceInfo() {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        let currency = ETHCurrency.ethCurrency
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let entity: WalletBalanceEntity?
            switch result {
            case .success(let balance):
                let currency = Constants.ETHConstants.ETHSymbol
                strongSelf.lastUpdatedCurrentBalance = balance
                entity = WalletBalanceEntity(
                    balanceWithCurrency: strongSelf.mapAttributedStringForBalance(symbol: currency,
                                                                                  amount: balance.valueWithDecimals.toFormattedCropNumber())
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
        
        updateService.obtainRate(for: currency) { [weak self] result in
            switch result {
            case .success(let model):
                self?.lastUpdatedCurrentBalanceRate = model.rate
                
            case .failure:
                DispatchQueue.main.async {
                    self?.output.didGetNoRates(for: currency)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateRate()
            }
        }
    }
    
    func updateTokenBalanceInfo() {
        guard let wallet = try? authService.getCurrentWallet(),
            let currency = settingsConfiguration.additionalToken else {
            return
        }
        
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let entity: WalletTokenBalanceEntity?
            switch result {
            case .success(let balance):
                strongSelf.lastUpdatedTokenBalance = balance
                let balance = balance.valueWithDecimals
                let currency = currency.symbol
                entity = WalletTokenBalanceEntity(
                    tokenBalanceWithCurrency: strongSelf.mapAttributedStringForToken(symbol: currency, amount: balance.toFormattedCropNumber()),
                    tokenBalanceWithCurrencyCompact: nil
                )

            case .failure:
                entity = self?.obtainInitialTokenBalanceEntity()
            }
                                    
            if let entity = entity {
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateTokenBalance(entity: entity)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateRate()
            }
        }
        
        updateService.obtainRate(for: currency) { [weak self] result in
            switch result {
            case .success(let model):
                self?.lastUpdatedTokenBalanceRate = model.rate
                
            case .failure:
                DispatchQueue.main.async {
                    self?.output.didGetNoRates(for: currency)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateRate()
            }
        }
    }
    
    func isRatesLoaded(for currency: Currency) -> Bool {
        if currency.isToken {
            return lastUpdatedTokenBalanceRate != nil
        } else {
            return lastUpdatedCurrentBalanceRate != nil
        }
    }
    
    private func updateRate() {
        if let balance = lastUpdatedCurrentBalance, let rate = lastUpdatedCurrentBalanceRate,
            let tokenBalance = lastUpdatedTokenBalance, let tokenRate = lastUpdatedTokenBalanceRate {
            let sum = sumBalancesWithRate(
                first: WalletBalanceWithRateModel(balance: balance.valueWithDecimals, rate: rate),
                second: WalletBalanceWithRateModel(balance: tokenBalance.valueWithDecimals, rate: tokenRate)
            )
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: sum, symbol: usdCurrency.symbol)
            )
        } else if let balance = lastUpdatedCurrentBalance, let rate = lastUpdatedCurrentBalanceRate {
            let roundedRate = BigDecimalNumber(balance.valueWithDecimals).toFormattedCropNumber(multiplier: rate,
                                                                                                precision: usdCurrency.decimals)
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: roundedRate, symbol: usdCurrency.symbol)
            )
        } else if let tokenBalance = lastUpdatedTokenBalance, let tokenRate = lastUpdatedTokenBalanceRate {
            let roundedRate = BigDecimalNumber(tokenBalance.valueWithDecimals).toFormattedCropNumber(multiplier: tokenRate,
                                                                                                     precision: usdCurrency.decimals)
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: roundedRate, symbol: usdCurrency.symbol)
            )
        }
    }
    
    private func sumBalancesWithRate(first: WalletBalanceWithRateModel, second: WalletBalanceWithRateModel) -> String {
        let firstBalance = BigDecimalNumber(first.balance)
        let secondBalance = BigDecimalNumber(second.balance)
        let firstRate = BigDecimalNumber(first.rate).multiply(firstBalance)
        let secondRate = BigDecimalNumber(second.rate).multiply(secondBalance)
        
        let result = firstRate.add(secondRate)
        
        if result.isEqual(BigDecimalNumber(0)) {
            return emptyBalanceString
        } else {
            let value = result.stringValue(precisionAfterDecimalPoint: usdCurrency.decimals, rounded: false).toFormattedCropNumber()
            return value
        }
    }
    
    func obtainInitialBalanceEntity() -> WalletBalanceEntity {
        guard let wallet = try? authService.getCurrentWallet() else {
            return getEmptyBalanceEntity()
        }
        let currency = ETHCurrency.ethCurrency
        let balance = updateService.getLocalBalanceFor(wallet: wallet,
                                                       currency: currency)
        let attributedString = mapAttributedStringForBalance(symbol: currency.symbol,
                                                             amount: balance.valueWithDecimals.toFormattedCropNumber())
        
        return WalletBalanceEntity(balanceWithCurrency: attributedString)
    }
    
    func obtainInitialTokenBalanceEntity() -> WalletTokenBalanceEntity {
        guard let wallet = try? authService.getCurrentWallet(),
            let token = settingsConfiguration.additionalToken else {
            return getEmptyTokenBalanceEntity()
        }
        let balance = updateService.getLocalBalanceFor(wallet: wallet,
                                                       currency: token)
        let attributedString = mapAttributedStringForToken(symbol: token.symbol,
                                                           amount: balance.valueWithDecimals.toFormattedCropNumber())
        
        return WalletTokenBalanceEntity(tokenBalanceWithCurrency: attributedString,
                                        tokenBalanceWithCurrencyCompact: nil)
    }
    
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity {
        var balance = Amount(value: emptyBalanceString, decimals: Constants.ETHConstants.ETHDecimal)
        var tokenBalance = Amount(value: emptyBalanceString, decimals: Constants.ETHConstants.ETHDecimal)
        var balanceRate = emptyBalanceString
        var tokenBalanceRate = emptyBalanceString
        
        if let wallet = try? authService.getCurrentWallet() {
            let currency = ETHCurrency.ethCurrency
            balance = updateService.getLocalBalanceFor(wallet: wallet, currency: currency)
            balanceRate = updateService.getLocalRate(for: currency)
            
            if let token = settingsConfiguration.additionalToken {
                tokenBalance = updateService.getLocalBalanceFor(wallet: wallet, currency: token)
                tokenBalanceRate = updateService.getLocalRate(for: token)
            }
        }
        
        let sum = sumBalancesWithRate(
            first: WalletBalanceWithRateModel(balance: balance.valueWithDecimals, rate: balanceRate),
            second: WalletBalanceWithRateModel(balance: tokenBalance.valueWithDecimals, rate: tokenBalanceRate)
        )
        
        return WalletBalanceRateEntity(rate: sum, symbol: usdCurrency.symbol)
    }
    
    func obtainInitialFeeEntity() -> SendFeeEntity {
        let entity = SendFeeEntity(fee: Constants.ETHConstants.ETHStandartFee.toLocaleSeparator())
        return entity
    }
    
    func obtainAllBalance(currency: Currency) -> SendAmountEntity {
        if currency.isToken {
            if let tokenBalance = lastUpdatedTokenBalance {
                var currencyAmount: String? = nil
                if let rate = lastUpdatedTokenBalanceRate {
                    currencyAmount = calculateFormattedCurrencyAmount(
                        amount: tokenBalance.valueWithDecimals,
                        rate: rate
                    )
                }
                return SendAmountEntity(
                    amount: tokenBalance.valueWithDecimals.toLocaleSeparator(),
                    currencyAmount: currencyAmount
                )
            }
        } else {
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
                        currencyAmount = calculateFormattedCurrencyAmount(
                            amount: diffWithDecimals,
                            rate: rate
                        )
                    }
                    return SendAmountEntity(amount: diffWithDecimals.toLocaleSeparator(), currencyAmount: currencyAmount)
                }
            }
        }

        return SendAmountEntity(amount: .none, currencyAmount: .none)
    }
    
    func updateCurrencyAmount(for currency: Currency, amount: String) -> SendAmountEntity {
        let lastUpdatedRate: String? = currency.isToken ? lastUpdatedTokenBalanceRate : lastUpdatedCurrentBalanceRate
        
        if let rate = lastUpdatedRate, !amount.isEmpty {
            let formattedCurrencyAmount = calculateFormattedCurrencyAmount(amount: amount, rate: rate)
            return SendAmountEntity(amount: .none, currencyAmount: formattedCurrencyAmount)
        }
        
        return SendAmountEntity(amount: .none, currencyAmount: .none)
    }
    
    func updateAmount(for currency: Currency, amount: String) -> SendAmountEntity {
        let lastUpdatedRate: String? = currency.isToken ? lastUpdatedTokenBalanceRate : lastUpdatedCurrentBalanceRate
        
        if let rate = lastUpdatedRate, !amount.isEmpty {
            let formattedAmount = calculateFormattedAmount(for: currency, amount: amount, rate: rate)
            return SendAmountEntity(amount: formattedAmount, currencyAmount: .none)
        }
        
        return SendAmountEntity(amount: .none, currencyAmount: .none)
    }
    
    func calculateCurrencyForAmount(for currency: Currency, amount: String) -> SendAmountEntity {
        let lastUpdatedRate: String? = currency.isToken ? lastUpdatedTokenBalanceRate : lastUpdatedCurrentBalanceRate
        
        if let rate = lastUpdatedRate, !amount.isEmpty, isValidFormat(amount: amount, currency: currency) {
            let formattedCurrency = calculateFormattedCurrencyAmount(amount: amount, rate: rate)
            return SendAmountEntity(amount: amount, currencyAmount: formattedCurrency)
        }
        return SendAmountEntity(amount: amount, currencyAmount: .none)
    }
    
    func isValidAmountFormat(for currency: Currency, amount: String) -> Bool {
        return isValidFormat(amount: amount, currency: currency)
    }
    
    func isValidCurrencyAmountFormat(amount: String) -> Bool {
        return isValidFormat(amount: amount, currency: usdCurrency)
    }
    
    //validate amount and show error exept empty string
    func validateAmount(amount: String, currency: Currency) -> SendErrorEntity? {
        guard (isValidFormat(amount: amount, currency: currency)
            && isValidAmountValue(amount: amount, currency: currency)
            && !amount.isEmpty) == false else {
            return nil
        }
        let amountError = R.string.localization.sendFlowErrorNoAmount()
        let error = SendErrorEntity(amountError: amountError, feeError: nil, toAddressError: nil)
        return error
    }
    
    func validateCurrencyAmount(amount: String, currency: Currency) -> SendErrorEntity? {
        if !isValidFormat(amount: amount, currency: currency) || amount.isEmpty {
            let amountError = R.string.localization.sendFlowErrorNoAmount()
            return SendErrorEntity(amountError: amountError, feeError: nil, toAddressError: nil)
        }
        let lastUpdatedRate = currency.isToken ? lastUpdatedTokenBalanceRate : lastUpdatedCurrentBalanceRate
        if let balanceRate = lastUpdatedRate {
            let amount = calculateFormattedAmount(for: currency, amount: amount, rate: balanceRate)
            return validateAmount(amount: amount, currency: currency)
        }
        return .none
    }
    
    func validateToAddress(address: String) -> SendErrorEntity? {
        guard (isValidETHAddress(address) && !isMineETHAddress(address)) == false else {
            return nil
        }
        let toAddressError = R.string.localization.sendFlowErrorToAccountNotFound()
        let error = SendErrorEntity(amountError: nil, feeError: nil, toAddressError: toAddressError)
        return error
    }

    //validate amount and address with error
    func validateInputs(inputs: SendInputs) -> SendErrorEntity? {
        let amountError = validateAmount(amount: inputs.amount, currency: inputs.currency)
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
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func countFeeForTransaction(inputs: SendInputs) {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        let currency = inputs.currency
        let amount = Amount(userFrendlyValue: inputs.amount, decimals: currency.decimals)
        let toAddress = inputs.toAddress
        let validToAddress = isValidETHAddress(toAddress) ? toAddress : wallet.address

        transferService.estimate(fromAddress: wallet.address,
                                 toAddress: validToAddress,
                                 amount: amount.value,
                                 currency: currency) { [weak self] result in
            switch result {
            case .success(let fee):
                DispatchQueue.main.async { [weak self] in
                    let feeAmount = Amount(value: fee.fee.string(unitDecimals: 0),
                                           decimals: Constants.ETHConstants.ETHDecimal)
                    self?.lastUpdatedFee = feeAmount
                    let entity = SendFeeEntity(fee: feeAmount.valueWithDecimals.toFormattedCropNumber())
                    self?.output.didUpdateFee(entity: entity)
                }
                
            case .failure:
                break
            }
        }
    }
    
    func sendTransaction(inputs: SendInputs, seed: String) {
        let toAddress = inputs.toAddress
        let currency = inputs.currency
        let amount = Amount(userFrendlyValue: inputs.amount, decimals: currency.decimals)

        transferService.send(seed: seed,
                             toAddress: toAddress,
                             amount: amount.value,
                             currency: currency) { [weak self] result in
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
    
    func hasAdditionalToken() -> Bool {
        return settingsConfiguration.hasAdditionalToken
    }
    
    func obtainPayCurrency() -> PayCurrenciesModel {
        var currencies = [Currency]()
        currencies.append(ETHCurrency.ethCurrency)
        if let token = settingsConfiguration.additionalToken {
            currencies.append(token)
        }
        let model = PayCurrenciesModel(echoAssetsAndTokens: currencies)
        return model
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
        
        return regex.firstMatch(in: amount,
                                options: [],
                                range: NSRange(location: 0, length: amount.count)) != nil
    }
    
    private func calculateFormattedCurrencyAmount(amount: String, rate: String) -> String {
        let rate = BigDecimalNumber(amount).multiply(BigDecimalNumber(rate))
        let lowerValue = BigDecimalNumber(1).powerOfMinusTen(BigDecimalNumber(usdCurrency.decimals))
        if rate.isLess(BigDecimalNumber(lowerValue)) {
            return rate.stringValue(precisionAfterDecimalPoint: 2, rounded: false).toLocaleSeparator()
        }
        let rateWithPrecision = BigDecimalNumber(rate.stringValue(precisionAfterDecimalPoint: usdCurrency.decimals,
                                                                  rounded: false))
        let reducedRate = rateWithPrecision.reduceENotation()
        return reducedRate.toLocaleSeparator()
    }
    
    private func calculateFormattedAmount(for currency: Currency, amount: String, rate: String) -> String {
        let rate = BigDecimalNumber(amount).divide(BigDecimalNumber(rate))
        let rateWithPrecision = BigDecimalNumber(rate.stringValue(precisionAfterDecimalPoint: currency.decimals))
        let reducedRate = rateWithPrecision.reduceENotation()
        return reducedRate.toLocaleSeparator()
    }
    
    private func isValidETHAddress(_ ethAddress: String) -> Bool {
        return transferService.isValidAddress(ethAddress)
    }
    
    private func isMineETHAddress(_ ethAddress: String) -> Bool {
        guard let wallet = try? authService.getCurrentWallet() else {
            return false
        }
        return wallet.address.lowercased() == ethAddress.lowercased()
    }
    
    private func isValidAmountValue(amount: String, currency: Currency) -> Bool {
        guard let lastUpdatedCurrentBalance = lastUpdatedCurrentBalance, let lastUpdatedFee = lastUpdatedFee else {
            return false
        }
        
        guard BigDecimalNumber(amount).isGreater(BigDecimalNumber(0)) else {
            return false
        }
        
        if currency.isToken == false {
            let actualAmount = BigDecimalNumber(lastUpdatedCurrentBalance.value)
                .subtract(BigDecimalNumber(lastUpdatedFee.value))
            let actualAmountWithDecimals = actualAmount.powerOfMinusTen(BigDecimalNumber(lastUpdatedCurrentBalance.decimals))
            if BigDecimalNumber(actualAmountWithDecimals).isLess(BigDecimalNumber(amount)) {
                return false
            } else {
                return true
            }
        } else if let lastUpdatedTokenBalance = lastUpdatedTokenBalance {
            let actualAmount = BigDecimalNumber(lastUpdatedTokenBalance.valueWithDecimals)
            if actualAmount.isLess(BigDecimalNumber(amount)) {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    private func mapAttributedStringForBalance(symbol: String, amount: String) -> NSAttributedString {
        guard hasAdditionalToken() else {
            return mapAttributedStringForToken(symbol: symbol, amount: amount)
        }
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
    
    private func mapAttributedStringForToken(symbol: String, amount: String) -> NSAttributedString {
        let balance = NSMutableAttributedString(
            string: amount,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 20) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.dark() ?? .blue
            ]
        )
        
        let currency = NSMutableAttributedString(
            string: " " + symbol,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 12) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .blue
            ]
        )
        
        balance.append(currency)
        return balance
    }
    
    private func getEmptyBalanceEntity() -> WalletBalanceEntity {
        let totalBalance = "0"
        let balanceCurrency = ETHCurrency.ethCurrency.symbol
        return WalletBalanceEntity(
            balanceWithCurrency: mapAttributedStringForBalance(symbol: balanceCurrency,
                                                               amount: totalBalance.toFormattedCropNumber())
        )
    }
    
    private func getEmptyTokenBalanceEntity() -> WalletTokenBalanceEntity {
        let totalBalance = "0"
        var balanceCurrency = ""
        if let token = settingsConfiguration.additionalToken {
            balanceCurrency = token.symbol
        }
        
        return WalletTokenBalanceEntity(
            tokenBalanceWithCurrency: mapAttributedStringForToken(symbol: balanceCurrency,
                                                                  amount: totalBalance.toFormattedCropNumber()),
            tokenBalanceWithCurrencyCompact: nil
        )
    }
}

extension SendInteractor: ETHUpdateEventDelegate {
    func didUpdateBalance(wallet: ETHWallet) {
        updateBalanceInfo()
    }
}
