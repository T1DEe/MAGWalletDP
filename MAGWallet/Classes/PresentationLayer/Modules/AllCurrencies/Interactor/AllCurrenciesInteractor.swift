//
//  AllCurrenciesAllCurrenciesInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AllCurrenciesInteractor {
    weak var output: AllCurrenciesInteractorOutput!
    
    let emptyBalanceString = "0"
    let usdCurrency = Currencies.usd
    
    var ratesCache: [String: AllCurrenciesRateStoreModel] = [:]
}

// MARK: - AllCurrenciesInteractorInput

extension AllCurrenciesInteractor: AllCurrenciesInteractorInput {
    func getModels(accounts: [AccountInfo]) -> [AllCurrenciesScreenModel] {
        var models = [AllCurrenciesScreenModel]()
        accounts.forEach { account in
            let model = prepareModel(account: account)
            models.append(model)
        }

        return models
    }
    
    private func getSingleModel(account: AccountInfo) -> AllCurrenciesScreenSingleModel {
        let model = mapEmptyScreenSingleModel(account: account)
        
        account.obtainCurrentWalletBalance { [weak model, weak account, weak self] result in
            guard let self = self, let account = account, let model = model else {
                return
            }
            switch result {
            case .success(let balance):
                let balanceModel = self.mapBalanceScreenModel(
                    balance: balance.toFormattedCropNumber(),
                    currency: account.obtainWalletCurrency()
                )
                model.balance = balanceModel
                let walletCurrency = account.obtainWalletCurrency()
                DispatchQueue.main.async { [weak self] in
                    self?.addToCache(balance: balance, rate: .none, currency: walletCurrency)
                    if let rateModel = self?.retrieveFromCache(currency: walletCurrency) {
                        model.rate = rateModel
                    }
                    
                    self?.output.didUpdateAccount()
                }
                
            default:
                break
            }
        }
        
        account.obtainRate { [weak model, weak account, weak self] result in
            guard let self = self, let model = model, let account = account else {
                return
            }
            switch result {
            case .success(let rate):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    let walletCurrency = account.obtainWalletCurrency()
                    self.addToCache(balance: .none, rate: rate, currency: walletCurrency)
                    if let rateModel = self.retrieveFromCache(currency: walletCurrency) {
                        model.rate = rateModel
                    }
                    self.output.didUpdateAccount()
                }
                
            default:
                break
            }
        }
        
        return model
    }
    
    private func getDuoModel(account: AccountInfo) -> AllCurrenciesScreenDuoModel {
        let model = mapEmptyScreenDuoModel(account: account)
        
        account.obtainCurrentWalletBalance { [weak model, weak account, weak self] result in
            guard let self = self, let account = account else {
                return
            }
            switch result {
            case .success(let balance):
                let balanceModel = self.mapBalanceScreenModel(
                    balance: balance.toFormattedCropNumber(),
                    currency: account.obtainWalletCurrency()
                )
                model?.firstBalance = balanceModel
                let walletCurrency = account.obtainWalletCurrency()
                
                DispatchQueue.main.async { [weak self] in
                    self?.addToCache(balance: balance, rate: .none, currency: walletCurrency)
                    if let rateModel = self?.retrieveFromCache(currency: walletCurrency) {
                        model?.firstRate = rateModel
                    }
                    self?.output.didUpdateAccount()
                }
                
            default:
                break
            }
        }
        
        account.obtainRate { [weak model, weak account, weak self] result in
            guard let self = self, let model = model, let account = account else {
                return
            }
            switch result {
            case .success(let rate):
                DispatchQueue.main.async { [weak model, weak account, weak self] in
                    guard let self = self, let model = model, let account = account else {
                        return
                    }
                    let walletCurrency = account.obtainWalletCurrency()
                    self.addToCache(balance: .none, rate: rate, currency: walletCurrency)
                    if let rateModel = self.retrieveFromCache(currency: walletCurrency) {
                        model.firstRate = rateModel
                    }
                    
                    self.output.didUpdateAccount()
                }
                
            default:
                break
            }
        }
        
        account.obtainCurrentTokenBalance { [weak model, weak account, weak self] result in
            guard let self = self, let account = account, let model = model else {
                return
            }
            switch result {
            case .success(let balance):
                guard let tokenCurrency = try? account.obtainTokenCurrency() else {
                    return
                }
                let balanceModel = self.mapBalanceScreenModel(
                    balance: balance.toFormattedCropNumber(),
                    currency: tokenCurrency
                )
                model.secondBalance = balanceModel
                let walletCurrency = account.obtainWalletCurrency()
                
                DispatchQueue.main.async { [weak self] in
                    self?.addToCache(balance: balance, rate: .none, currency: walletCurrency, token: tokenCurrency)
                    if let rateModel = self?.retrieveFromCache(currency: walletCurrency, token: tokenCurrency) {
                        model.secondRate = rateModel
                    }
                    self?.output.didUpdateAccount()
                }
                
            default:
                break
            }
        }
        
        account.obtainTokenRate { [weak model, weak account, weak self] result in
            guard let self = self, let model = model, let account = account else {
                return
            }
            switch result {
            case .success(let tokenRate):
                DispatchQueue.main.async { [weak model, weak account, weak self] in
                    guard let self = self, let model = model, let account = account else {
                        return
                    }
                    guard let tokenCurrency = try? account.obtainTokenCurrency() else {
                        return
                    }
                    let walletCurrency = account.obtainWalletCurrency()
                    self.addToCache(balance: .none, rate: tokenRate, currency: walletCurrency, token: tokenCurrency)
                    if let rateModel = self.retrieveFromCache(currency: walletCurrency, token: tokenCurrency) {
                        model.secondRate = rateModel
                    }
                    
                    self.output.didUpdateAccount()
                }
                
            default:
                break
            }
        }
        
        return model
    }
    
    private func getEmptyModel(account: AccountInfo) -> AllCurrenciesScreenEmptyModel {
        let icon = account.obtainWalletIcon()
        let name = account.obtainWalletName()
        let currency = AllCurrenciesScreenCurrencyModel(icon: icon, name: name)
        let model = AllCurrenciesScreenEmptyModel(currency: currency)
        model.additionObject = account
        return model
    }
    
    private func prepareModel(account: AccountInfo) -> AllCurrenciesScreenModel {
        guard account.hasAccounts() == true else {
            let model = getEmptyModel(account: account)
            return model
        }
        
        guard let _ = try? account.obtainTokenCurrency() else {
            let model = getSingleModel(account: account)
            return model
        }
        
        let model = getDuoModel(account: account)
        return model
    }
    
    private func mapBalanceScreenModel(balance: String, currency: String) -> AllCurrenciesScreenAmountModel {
        let balanceModel = AllCurrenciesScreenAmountModel(
            amount: balance,
            symbol: currency
        )
        return balanceModel
    }
    
    private func mapRateScreenModel(rate: String, balance: String) -> AllCurrenciesScreenAmountModel {
        let roundedRate = BigDecimalNumber(balance).toFormattedCropNumber(multiplier: rate, precision: usdCurrency.decimals)
        let rateModel = AllCurrenciesScreenAmountModel(
            amount: roundedRate,
            symbol: usdCurrency.symbol
        )
        
        return rateModel
    }
    
    private func mapEmptyScreenSingleModel(account: AccountInfo) -> AllCurrenciesScreenSingleModel {
        let icon = account.obtainWalletIcon()
        let name = account.obtainWalletName()

        let currency = AllCurrenciesScreenCurrencyModel(icon: icon, name: name)
        let currencyString = account.obtainWalletCurrency()
        
        let emptyBalance = AllCurrenciesScreenAmountModel(amount: emptyBalanceString, symbol: currencyString)
        let emptyRate = AllCurrenciesScreenAmountModel(amount: emptyBalanceString, symbol: usdCurrency.symbol)
        
        let model = AllCurrenciesScreenSingleModel(currency: currency, balance: emptyBalance, rate: emptyRate)
        model.additionObject = account
        
        return model
    }
    
    private func mapEmptyScreenDuoModel(account: AccountInfo) -> AllCurrenciesScreenDuoModel {
        let icon = account.obtainWalletIcon()
        let name = account.obtainWalletName()
        let tokenName = (try? account.obtainTokenName()) ?? ""

        let currency = AllCurrenciesScreenCurrencyModel(icon: icon, name: name)
        let tokenCurrency = AllCurrenciesScreenCurrencyModel(icon: icon, name: tokenName)
        
        let currencyString = account.obtainWalletCurrency()
        let emptyBalance = AllCurrenciesScreenAmountModel(
            amount: emptyBalanceString,
            symbol: currencyString
        )
        
        let currencyTokenString = account.obtainWalletCurrency()
        let emptyCurrencyBalance = AllCurrenciesScreenAmountModel(
            amount: emptyBalanceString, symbol: currencyTokenString
        )
        
        let emptyRate = AllCurrenciesScreenAmountModel(amount: emptyBalanceString, symbol: usdCurrency.symbol)
        
        let model = AllCurrenciesScreenDuoModel(firstCurrency: currency,
                                                firstBalance: emptyBalance,
                                                secondCurrency: tokenCurrency,
                                                secondBalance: emptyCurrencyBalance,
                                                firstRate: emptyRate, secondRate: emptyRate)
        
        model.additionObject = account
        
        return model
    }
    
    func addToCache(balance: String?, rate: String?, currency: String, token: String = "") {
        let key = currency + token
        if var value = self.ratesCache[key] {
            value.balance = balance ?? value.balance
            value.rate = rate ?? value.rate
            self.ratesCache[key] = value
        } else {
            self.ratesCache[key] = AllCurrenciesRateStoreModel(rate: rate, balance: balance)
        }
    }
    
    func retrieveFromCache(currency: String, token: String = "") -> AllCurrenciesScreenAmountModel? {
        let key = currency + token
        guard let value = ratesCache[key], let balance = value.balance, let rate = value.rate else {
            return .none
        }
        return mapRateScreenModel(rate: rate, balance: balance)
    }
}
