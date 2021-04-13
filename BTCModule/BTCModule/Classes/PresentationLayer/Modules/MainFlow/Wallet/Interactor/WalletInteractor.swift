//
//  WalletWalletInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import UIKit

class WalletInteractor {
    weak var output: WalletInteractorOutput!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var authService: BTCAuthService!
    var updateService: BTCUpdateService!
    var btcUpdateDelegateHandler: BTCUpdateEventDelegateHandler!
    var authEventDelegateHandler: AuthEventDelegateHandler!
    let emptyBalanceString = "0"
    let usdCurrency = Currencies.usd
    var rates: BalancesAndRatesStoreModel!
}

// MARK: - WalletInteractorInput

extension WalletInteractor: WalletInteractorInput {
    func bindToEvents() {
        btcUpdateDelegateHandler.delegate = self
        authEventDelegateHandler.delegate = self
    }
    
    func obtainInitialEntity() -> WalletEntity {
        guard let wallet = try? authService.getCurrentWallet() else {
            return getEmptyEntity()
        }
        
        let balance = emptyBalanceString
        let currency = Constants.BTCConstants.BTCSymbol
        let attributedText = mapAttributedStringForBalance(symbol: currency,
                                                           symbolSize: 20,
                                                           amount: balance.toFormattedCropNumber(),
                                                           amountSize: 34)
        let attributedTextCompact = mapAttributedStringForBalance(symbol: currency,
                                                                  symbolSize: 12,
                                                                  amount: balance.toFormattedCropNumber(),
                                                                  amountSize: 20)
        let entity = WalletEntity(
            address: wallet.address,
            balanceWithCurrency: attributedText,
            balanceWithCurrencyCompact: attributedTextCompact
        )
        return entity
    }
    
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity {
        var balance = emptyBalanceString
        var balanceRate = emptyBalanceString
        
        if let wallet = try? authService.getCurrentWallet() {
            balance = updateService.getLocalBalanceFor(wallet: wallet)
            balanceRate = updateService.getLocalRate()
        }
        
        let satoshi = satoshiToBTC(satoshi: balance)
        let formattedBalance = BigDecimalNumber(satoshi).toFormattedCropNumber(multiplier: balanceRate,
                                                                               precision: usdCurrency.decimals)
        
        return WalletBalanceRateEntity(rate: formattedBalance, symbol: usdCurrency.symbol)
    }
    
    private func mapAttributedStringForBalance(symbol: String, symbolSize: CGFloat, amount: String, amountSize: CGFloat) -> NSAttributedString {
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
    
    func updateBalanceInfo() {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        
        rates = .none
        
        updateService.updateWalletBalance(wallet: wallet) { [weak self] result in
            guard let self = self else {
                return
            }
            let entity: WalletEntity?
            switch result {
            case .success(let balance):
                let amount = self.satoshiToBTC(satoshi: balance)
                let currency = Constants.BTCConstants.BTCSymbol
                let balanceWithCurrency = self.mapAttributedStringForBalance(symbol: currency,
                                                                             symbolSize: 20,
                                                                             amount: amount.toFormattedCropNumber(),
                                                                             amountSize: 34)
                let compactBalanceWithCurrency = self.mapAttributedStringForBalance(symbol: currency,
                                                                                    symbolSize: 12,
                                                                                    amount: amount.toFormattedCropNumber(),
                                                                                    amountSize: 20)
                entity = WalletEntity(address: wallet.address,
                                      balanceWithCurrency: balanceWithCurrency,
                                      balanceWithCurrencyCompact: compactBalanceWithCurrency)
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(balance: amount, rate: .none)
                }
                
            case .failure:
                entity = self.obtainInitialEntity()
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(balance: .none, rate: .none)
                }
            }
            
            if let entity = entity {
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateBalance(entity: entity)
                }
            }
        }
        
        updateService.obtainRate { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(balance: .none, rate: model.rate)
                }
                
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(balance: .none, rate: .none)
                }
            }
        }
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    // MARK: Private
    
    private func updateRate(balance: String?, rate: String?) {
        if balance == .none && rate == .none {
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: emptyBalanceString, symbol: usdCurrency.symbol)
            )
            return
        }
        
        if rates == nil {
            rates = getEmptyAllBalancesWithRatesModel()
        }
        
        rates.balance = balance ?? rates.balance
        rates.balanceRate = rate ?? rates.balanceRate
        
        if let balance = rates.balance, let balanceRate = rates.balanceRate {
            let roundedRate = BigDecimalNumber(balance).toFormattedCropNumber(multiplier: balanceRate,
                                                                              precision: usdCurrency.decimals)
            output.didUpdateBalanceRate(
                entity: WalletBalanceRateEntity(rate: roundedRate, symbol: usdCurrency.symbol)
            )
        }
    }
    
    private func getEmptyEntity() -> WalletEntity {
        return WalletEntity(
            address: String(),
            balanceWithCurrency: NSAttributedString(),
            balanceWithCurrencyCompact: nil
        )
    }
    
    private func satoshiToBTC(satoshi: String) -> String {
        return BigDecimalNumber(satoshi).powerOfMinusTen(BigDecimalNumber(Constants.BTCConstants.BTCDecimal))
    }
    
    private func getEmptyAllBalancesWithRatesModel() -> BalancesAndRatesStoreModel {
        return BalancesAndRatesStoreModel(balance: .none, balanceRate: .none)
    }
}

// MARK: - AuthEventDelegate

extension WalletInteractor: AuthEventDelegate {
    func didNewWalletSelected() {
        output.didNewWalletSelected()
    }
    
    func didAuthCompleted() {
    }
}

// MARK: - BTCUpdateEventDelegate

extension WalletInteractor: BTCUpdateEventDelegate {
    func didUpdateBalance() {
        updateBalanceInfo()
    }
}
