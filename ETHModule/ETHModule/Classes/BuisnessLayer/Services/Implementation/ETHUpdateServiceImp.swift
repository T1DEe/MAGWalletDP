//
//  ETHUpdateFacadeImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoAPI
import SharedFilesModule

final class ETHUpdateServiceImp: ETHUpdateService {
    var networkAdapter: ETHNetworkAdapter!
    var storageService: PublicDataService!
    
    func getLocalBalanceFor(wallet: ETHWallet, currency: Currency) -> Amount {
        return loadBalanceFor(wallet, currency: currency)
    }
    
    func getLocalBalancesFor(wallets: [ETHWallet], currency: Currency) -> [ETHWallet: Amount] {
        return loadBalancesFor(wallets, currency: currency)
    }
    
    func updateWalletBalance(wallet: ETHWallet,
                             currency: Currency,
                             completion: ETHUpdateCompletionHadler<Amount>?) {
        if currency.isToken {
            updateTokenBalance(wallet: wallet, currency: currency, completion: completion)
        } else {
            updateAmountBalance(wallet: wallet, completion: completion)
        }
    }
    
    func updateWalletsBalances(wallets: [ETHWallet], currency: Currency, completion: ETHUpdateCompletionHadler<[ETHWallet: Amount]>?) {
        var balances = [ETHWallet: Amount]()
        var wasError = false
        for wallet in wallets {
            updateWalletBalance(wallet: wallet, currency: currency) { result in
                guard wasError == false else {
                    return
                }
                
                switch result {
                case .success(let amount):
                    balances[wallet] = amount
                    if balances.count == wallets.count {
                        completion?(.success(balances))
                    }
                    
                case .failure(let error):
                    wasError = true
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func obtainWalletHistory(wallet: ETHWallet,
                             currency: Currency,
                             from: Int?,
                             limit: Int?,
                             completion: @escaping ETHUpdateCompletionHadler<ETHPagedResponse<ETHWalletHistoryEntity>>) {
        obtainAmountHistory(wallet: wallet, from: from, limit: limit, completion: completion)
    }
    
    private func obtainAmountHistory(wallet: ETHWallet,
                                     from: Int?,
                                     limit: Int?,
                                     completion: @escaping ETHUpdateCompletionHadler<ETHPagedResponse<ETHWalletHistoryEntity>>) {
        let address = wallet.address
        networkAdapter.history(address: address, from: from, limit: limit) { result in
            do {
                let history = try result()
                completion(.success(history))
            } catch {
                completion(.failure(.mappingError))
            }
        }
    }
    
    func obtainTokenHistory(wallet: ETHWallet,
                            currency: Currency,
                            from: Int?,
                            limit: Int?,
                            completion: @escaping ETHUpdateCompletionHadler<ETHPagedResponse<ETHWalletTokenHistoryEntity>>) {
        let address = wallet.address
        let tokenAddress = currency.id
        networkAdapter.tokenHistory(tokenAddress: tokenAddress, address: address, from: from, limit: limit) { result in
            do {
                let history = try result()
                completion(.success(history))
            } catch {
                completion(.failure(.mappingError))
            }
        }
    }
    
    func obtainRate(for currency: Currency, completion: @escaping ETHUpdateCompletionHadler<ETHCoinRateModel>) {
        guard let currencyType = CryptoCurrencyType(rawValue: currency.symbol) else {
            completion(.failure(.mappingError))
            return
        }
        networkAdapter.rate(coin: currencyType) { [weak self] result in
            guard let self = self else {
                return
            }
            
            do {
                let rate = try result()
                completion(.success(rate))
                
                let key = currency.isToken ? self.createTokenRateKey() : self.createRateKey()
                self.storeRate(key: key, rate: rate.rate)
            } catch {
                completion(.failure(.mappingError))
            }
        }
    }
    
    func getLocalRate(for currency: Currency) -> String {
        let key = currency.isToken ? createTokenRateKey() : createRateKey()
        return loadRate(key: key)
    }
    
    func obtainRatesHistory(for currency: Currency, completion: @escaping ETHUpdateCompletionHadler<[ETHCoinHistoryRateModel]>) {
        guard let currencyType = CryptoCurrencyType(rawValue: currency.symbol) else {
            completion(.failure(.mappingError))
            return
        }
        networkAdapter.rateHistory(coin: currencyType) { result in
            do {
                let rates = try result()
                completion(.success(rates))
            } catch {
                completion(.failure(.mappingError))
            }
        }
    }
    
    private func updateAmountBalance(wallet: ETHWallet,
                                     completion: ETHUpdateCompletionHadler<Amount>?) {
        let address = wallet.address
        networkAdapter.balance(address: address) { [weak self] result in
            guard let self = self else {
                return
            }
            
            do {
                let balance = try result()
                let convertedBalance = self.converBalances(balance: balance)
                completion?(.success(convertedBalance))
                let currency = ETHCurrency.ethCurrency
                self.storeBalanceFor(wallet, amount: convertedBalance, currency: currency)
            } catch {
                completion?(.failure(.mappingError))
            }
        }
    }
    
    private func updateTokenBalance(wallet: ETHWallet,
                                    currency: Currency,
                                    completion: ETHUpdateCompletionHadler<Amount>?) {
        let address = wallet.address
        let tokenAddress = currency.id
        networkAdapter.tokenBalance(address: address, tokenAddress: tokenAddress) { [weak self] result in
            guard let self = self else {
                return
            }
            
            do {
                let balance = try result()
                let convertedBalance = self.converTokenBalances(balance: balance, decimals: currency.decimals)
                completion?(.success(convertedBalance))
                self.storeBalanceFor(wallet, amount: convertedBalance, currency: currency)
            } catch {
                completion?(.failure(.mappingError))
            }
        }
    }
    
    private func converBalances(balance: ETHWalletBalanceModel) -> Amount {
        let balance = balance.balance
        let decimals = Constants.ETHConstants.ETHDecimal
        return Amount(value: balance, decimals: decimals)
    }
    
    private func converTokenBalances(balance: ETHWalletBalanceModel, decimals: Int) -> Amount {
        let balance = balance.balance
        return Amount(value: balance, decimals: decimals)
    }
    
    // MARK: Store balances
    
    private func createBalanceKey(currency: Currency) -> String {
        return currency.symbol + Constants.InfoConstants.balancesKey
    }
    
    private func createRateKey() -> String {
        return Constants.ETHConstants.ETHSymbol + Constants.InfoConstants.rateKey
    }
    
    private func createTokenRateKey() -> String {
        return Constants.ETHConstants.ETHSymbol + Constants.InfoConstants.tokenRateKey
    }
    
    private func createZeroAmount(currency: Currency) -> Amount {
        return Amount(value: "0", decimals: currency.decimals)
    }
    
    private func storeBalanceFor(_ wallet: ETHWallet, amount: Amount, currency: Currency) {
        let key = createBalanceKey(currency: currency)
        let balances: [String: Amount]
        if var savedBalances = try? storageService.obtainPublicData(key: key,
                                                                    type: [String: Amount].self) {
            savedBalances[wallet.address] = amount
            balances = savedBalances
        } else {
            balances = [wallet.address: amount]
        }
        try? storageService.setPublicData(key: key, data: balances)
    }
    
    private func storeRate(key: String, rate: String) {
        try? storageService.setPublicData(key: key, data: rate)
    }
    
    private func loadRate(key: String) -> String {
        if let rate = try? storageService.obtainPublicData(key: key, type: String.self) {
            return rate
        } else {
            return "0"
        }
    }
    
    private func loadBalanceFor(_ wallet: ETHWallet, currency: Currency) -> Amount {
        let key = createBalanceKey(currency: currency)
        var amount: Amount? = nil
        if let savedBalances = try? storageService.obtainPublicData(key: key,
                                                                    type: [String: Amount].self) {
            amount = savedBalances[wallet.address]
        }
        
        if let amount = amount {
            return amount
        } else {
            return createZeroAmount(currency: currency)
        }
    }
    
    private func loadBalancesFor(_ wallets: [ETHWallet], currency: Currency) -> [ETHWallet: Amount] {
        let key = createBalanceKey(currency: currency)
        var balances = [String: Amount]()
        if let savedBalances = try? storageService.obtainPublicData(key: key,
                                                                    type: [String: Amount].self) {
            balances = savedBalances
        }
        
        var amounts = [ETHWallet: Amount]()
        wallets.forEach {
            let amount: Amount
            if let savedAmount = balances[$0.address] {
                amount = savedAmount
            } else {
                amount = createZeroAmount(currency: currency)
            }
            amounts[$0] = amount
        }
        
        return amounts
    }
}

extension ETHUpdateServiceImp: ETHNetworkConfigurable {
    func configure(with networkType: ETHNetworkType) {
        // Not used
    }
    func configure(with networkAdapter: ETHNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
}
