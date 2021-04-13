//
//  LTCUpdateServiceImp.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class LTCUpdateServiceImp: LTCUpdateService {
    var networkAdapter: LTCNetworkAdapter!
    var storageService: PublicDataService!
    var currentNetwork: LTCNetworkType!
    
    func getLocalBalanceFor(wallet: LTCWallet) -> String {
        return loadBalanceFor(wallet)
    }
    
    func getLocalBalancesFor(wallets: [LTCWallet]) -> [LTCWallet: String] {
        return loadBalancesFor(wallets)
    }
    
    func getLocalRate() -> String {
        return loadRateFor(currency: Constants.LTCConstants.LTCSymbol)
    }
    
    func updateWalletBalance(wallet: LTCWallet, completion: LTCUpdateCompletionHandler<String>?) {
        let address = wallet.address
        networkAdapter.balance(address: address) { [weak self] result in
            switch result {
            case .success(let balance):
                guard let balance = self?.mapBalance(balance) else {
                    completion?(.failure(.mappingError))
                    return
                }
                completion?(.success(balance))
                self?.storeBalanceFor(wallet, amount: balance)
                
            case .failure:
                completion?(.failure(.mappingError))
            }
        }
    }
    
    func updateWalletsBalances(wallets: [LTCWallet], completion: LTCUpdateCompletionHandler<[LTCWallet: String]>?) {
        var balances = [LTCWallet: String]()
        var wasError = false
        for wallet in wallets {
            updateWalletBalance(wallet: wallet) { result in
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
    
    func obtainWalletHistory(
        wallet: LTCWallet,
        skip: Int?,
        limit: Int?,
        completion: @escaping LTCUpdateCompletionHandler<LTCPagedResponse<LTCWalletHistoryModel>>
    ) {
        let address = wallet.address
        networkAdapter.history(address: address, skip: skip, limit: limit) { result in
            switch result {
            case .success(let history):
                completion(.success(history))
                
            case .failure:
                completion(.failure(.connectionFailed))
            }
        }
    }
    
    func obtainRate(completion: @escaping LTCUpdateCompletionHandler<LTCCoinRateModel>) {
        networkAdapter.rate { [weak self] result in
            switch result {
            case .success(let model):
                completion(.success(model))
                self?.storeRateFor(currency: Constants.LTCConstants.LTCSymbol, rate: model.rate)
                
            case .failure:
                completion(.failure(.connectionFailed))
            }
        }
    }
    
    func obtainRatesHistory(completion: @escaping LTCUpdateCompletionHandler<[LTCCoinHistoryRateModel]>) {
        networkAdapter.rateHistory { result in
            switch result {
            case .success(let models):
                completion(.success(models))
                
            case .failure:
                completion(.failure(.connectionFailed))
            }
        }
    }
    
    // MARK: - Store balances
    
    private func storeBalanceFor(_ wallet: LTCWallet, amount: String) {
        let key = Constants.InfoConstants.balancesKey
        let balances: [String: String]
        if var savedBalances = try? storageService.obtainPublicData(key: key,
                                                                    type: [String: String].self) {
            savedBalances[wallet.address] = amount
            balances = savedBalances
        } else {
            balances = [wallet.address: amount]
        }
        try? storageService.setPublicData(key: key, data: balances)
    }
    
    private func loadBalanceFor(_ wallet: LTCWallet) -> String {
        let key = Constants.InfoConstants.balancesKey
        var amount: String?
        if let savedBalances = try? storageService.obtainPublicData(key: key,
                                                                    type: [String: String].self) {
            amount = savedBalances[wallet.address]
        }
        
        if let amount = amount {
            return amount
        } else {
            return zeroAmount()
        }
    }
    
    private func loadBalancesFor(_ wallets: [LTCWallet]) -> [LTCWallet: String] {
        let key = Constants.InfoConstants.balancesKey
        var balances = [String: String]()
        if let savedBalances = try? storageService.obtainPublicData(key: key,
                                                                    type: [String: String].self) {
            balances = savedBalances
        }
        
        var amounts = [LTCWallet: String]()
        wallets.forEach {
            let amount: String
            if let savedAmount = balances[$0.address] {
                amount = savedAmount
            } else {
                amount = zeroAmount()
            }
            amounts[$0] = amount
        }
        
        return amounts
    }
    
    private func storeRateFor(currency: String, rate: String) {
        let key = currency + Constants.InfoConstants.rateKey
        try? storageService.setPublicData(key: key, data: rate)
    }
    
    private func loadRateFor(currency: String) -> String {
        let key = currency + Constants.InfoConstants.rateKey
        if let rate = try? storageService.obtainPublicData(key: key, type: String.self) {
            return rate
        } else {
            return zeroAmount()
        }
    }
    
    private func mapBalance(_ balance: LTCWalletBalanceModel) -> String {
        return balance.balance
    }
    
    private func zeroAmount() -> String {
        return "0"
    }
}

extension LTCUpdateServiceImp: LTCNetworkConfigurable {
    func configure(with networkAdapter: LTCNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
    
    func configure(with network: LTCNetworkType) {
        currentNetwork = network
    }
}
