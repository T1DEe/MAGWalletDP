//
//  WalletWithTokenWalletWithTokenInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class WalletWithTokenInteractor {
    weak var output: WalletWithTokenInteractorOutput!
    var authService: ETHAuthService!
    var updateService: ETHUpdateService!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var settingsConfiguration: ETHSettingsConfiguration!
    var ethUpdateDelegateHandler: ETHUpdateEventDelegateHandler!
    var authEventDelegateHandler: AuthEventDelegateHandler!
    var rates: WalletTokenBalancesStoreModel!
    let emptyBalanceString = "0"
    let usdCurrency = Currencies.usd
}

// MARK: - WalletWithTokenInteractorInput

extension WalletWithTokenInteractor: WalletWithTokenInteractorInput {
    func bindToEvents() {
        ethUpdateDelegateHandler.delegate = self
        authEventDelegateHandler.delegate = self
    }
    
    func obtainAddressEntity() -> WalletAddressEntity {
        guard let wallet = try? authService.getCurrentWallet() else {
            return WalletAddressEntity(address: "")
        }
        return WalletAddressEntity(address: wallet.address)
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
        let tokenBalanceWithCurrency = mapAttributedStringForToken(symbol: token.symbol,
                                                                   symbolSize: 20,
                                                                   amount: balance.valueWithDecimals.toFormattedCropNumber(),
                                                                   amountSize: 34)
        let tokenBalanceWithCurrencyCompact = mapAttributedStringForToken(symbol: token.symbol,
                                                                          symbolSize: 12,
                                                                          amount: balance.valueWithDecimals.toFormattedCropNumber(),
                                                                          amountSize: 20)
        
        return WalletTokenBalanceEntity(tokenBalanceWithCurrency: tokenBalanceWithCurrency,
                                        tokenBalanceWithCurrencyCompact: tokenBalanceWithCurrencyCompact)
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
    
    func updateBalanceInfo() {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        let currency = ETHCurrency.ethCurrency
        
        if rates != nil {
            rates.clearBalance()
        }
        
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { [weak self] result in
            guard let self = self else {
                return
            }
            let entity: WalletBalanceEntity?
            switch result {
            case .success(let balance):
                let symbol = Constants.ETHConstants.ETHSymbol
                entity = WalletBalanceEntity(
                    balanceWithCurrency: self.mapAttributedStringForBalance(symbol: symbol,
                                                                                  amount: balance.valueWithDecimals.toFormattedCropNumber())
                )
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: balance.valueWithDecimals, rate: .none)
                }
                
            case .failure:
                entity = self.obtainInitialBalanceEntity()
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: .none, rate: .none)
                }
            }
            
            if let entity = entity {
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateBalance(entity: entity)
                }
            }
        }
        
        updateService.obtainRate(for: currency) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let rate):
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: .none, rate: rate.rate)
                }
                
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: .none, rate: .none)
                }
            }
        }
    }
    
    func updateTokenBalanceInfo() {
        guard let wallet = try? authService.getCurrentWallet(),
            let currency = settingsConfiguration.additionalToken else {
            return
        }
        
        if rates != nil {
            rates.clearToken()
        }
        
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let entity: WalletTokenBalanceEntity?
            switch result {
            case .success(let balance):
                let balance = balance.valueWithDecimals
                let symbol = currency.symbol
                entity = WalletTokenBalanceEntity(
                    tokenBalanceWithCurrency: strongSelf.mapAttributedStringForToken(symbol: symbol,
                                                                                     symbolSize: 20,
                                                                                     amount: balance.toFormattedCropNumber(),
                                                                                     amountSize: 34),
                    tokenBalanceWithCurrencyCompact: strongSelf.mapAttributedStringForToken(symbol: symbol,
                                                                                            symbolSize: 12,
                                                                                            amount: balance.toFormattedCropNumber(),
                                                                                            amountSize: 20)
                )
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: balance, rate: .none)
                }
                
            case .failure:
                entity = self?.obtainInitialTokenBalanceEntity()
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: .none, rate: .none)
                }
            }
            
            if let entity = entity {
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateTokenBalance(entity: entity)
                }
            }
        }
        
        updateService.obtainRate(for: currency) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let rate):
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: .none, rate: rate.rate)
                }
                
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(for: currency, balance: .none, rate: .none)
                }
            }
        }
    }
    
    private func updateRate(for currency: Currency, balance: String?, rate: String?) {
        if rates == nil {
            rates = getEmptyBalancesStoreModel()
        }
        
        if currency.isToken {
            rates.tokenBalance = balance ?? rates.tokenBalance
            rates.tokenRate = rate ?? rates.tokenRate
        } else {
            rates.balance = balance ?? rates.balance
            rates.balanceRate = rate ?? rates.balanceRate
        }
        
        if let balance = rates.balance, let balanceRate = rates.balanceRate,
            let tokenBalance = rates.tokenBalance, let tokenRate = rates.tokenRate {
            let sum = sumBalancesWithRate(
                first: WalletBalanceWithRateModel(balance: balance, rate: balanceRate),
                second: WalletBalanceWithRateModel(balance: tokenBalance, rate: tokenRate)
            )
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: sum, symbol: usdCurrency.symbol)
            )
        } else if let balance = rates.balance, let balanceRate = rates.balanceRate {
            let roundedRate = BigDecimalNumber(balance).toFormattedCropNumber(multiplier: balanceRate,
                                                                              precision: usdCurrency.decimals)
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: roundedRate, symbol: usdCurrency.symbol)
            )
        } else if let tokenBalance = rates.tokenBalance, let tokenRate = rates.tokenRate {
            let roundedRate = BigDecimalNumber(tokenBalance).toFormattedCropNumber(multiplier: tokenRate,
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
    
    private func mapAttributedStringForBalance(symbol: String, amount: String) -> NSAttributedString {
        let balance = NSMutableAttributedString(
            string: amount,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 18) ?? UIFont.systemFont(ofSize: 12),
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
    
    private func mapAttributedStringForToken(symbol: String, symbolSize: CGFloat, amount: String, amountSize: CGFloat) -> NSAttributedString {
        let balance = NSMutableAttributedString(
            string: amount,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: amountSize) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.dark() ?? .blue
            ]
        )
        
        let currency = NSMutableAttributedString(
            string: " " + symbol,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: symbolSize) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .blue
            ]
        )
        
        balance.append(currency)
        return balance
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    // MARK: Private
    
    private func getEmptyBalanceEntity() -> WalletBalanceEntity {
        let totalBalance = emptyBalanceString
        let balanceCurrency = ETHCurrency.ethCurrency.symbol
        return WalletBalanceEntity(
            balanceWithCurrency: mapAttributedStringForBalance(symbol: balanceCurrency, amount: totalBalance.toFormattedCropNumber())
        )
    }
    
    private func getEmptyTokenBalanceEntity() -> WalletTokenBalanceEntity {
        let totalBalance = emptyBalanceString
        let balanceCurrency = settingsConfiguration.additionalToken?.symbol ?? ""
        
        return WalletTokenBalanceEntity(
            tokenBalanceWithCurrency: mapAttributedStringForToken(symbol: balanceCurrency,
                                                                  symbolSize: 20,
                                                                  amount: totalBalance.toFormattedCropNumber(),
                                                                  amountSize: 34),
            tokenBalanceWithCurrencyCompact: mapAttributedStringForToken(symbol: balanceCurrency,
                                                                         symbolSize: 12,
                                                                         amount: totalBalance.toFormattedCropNumber(),
                                                                         amountSize: 20)
        )
    }
    
    private func getEmptyBalancesStoreModel() -> WalletTokenBalancesStoreModel {
        return WalletTokenBalancesStoreModel(balance: .none, balanceRate: .none, tokenBalance: .none, tokenRate: .none)
    }
}

extension WalletWithTokenInteractor: ETHUpdateEventDelegate {
    func didUpdateBalance() {
        updateBalanceInfo()
        updateTokenBalanceInfo()
    }
}

// MARK: AuthEventDelegate

extension WalletWithTokenInteractor: AuthEventDelegate {
    func didNewWalletSelected() {
        output.didNewWalletSelected()
    }
    
    func didAuthCompleted() {
    }
}
