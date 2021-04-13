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
    var authService: ETHAuthService!
    var updateService: ETHUpdateService!
    var ethUpdateDelegateHandler: ETHUpdateEventDelegateHandler!
    var authEventDelegateHandler: AuthEventDelegateHandler!
    var rates: WalletBalancesStoreModel!
    let emptyBalanceString = "0"
    let usdCurrency = Currencies.usd
}

// MARK: - WalletInteractorInput

extension WalletInteractor: WalletInteractorInput {
    func bindToEvents() {
        ethUpdateDelegateHandler.delegate = self
        authEventDelegateHandler.delegate = self
    }
    
    func obtainInitialEntity() -> WalletEntity {
        guard let wallet = try? authService.getCurrentWallet() else {
            return getEmptyEntity()
        }

        let balance = emptyBalanceString
        let currency = Constants.ETHConstants.ETHSymbol
        let attributedText = mapAttributedStringForBalance(symbol: currency,
                                                           symbolSize: 20,
                                                           amount: balance,
                                                           amountSize: 34)
        let attributedTextCompact = mapAttributedStringForBalance(symbol: currency,
                                                                  symbolSize: 12,
                                                                  amount: balance,
                                                                  amountSize: 20)
        let entity = WalletEntity(
            address: wallet.address,
            balanceWithCurrency: attributedText,
            balanceWithCurrencyCompact: attributedTextCompact
        )
        return entity
    }

    func obtainInitialBalanceRate() -> WalletBalanceRateEntity {
        var balance = Amount(value: emptyBalanceString, decimals: Constants.ETHConstants.ETHDecimal)
        var balanceRate = emptyBalanceString
        
        if let wallet = try? authService.getCurrentWallet() {
            let currency = ETHCurrency.ethCurrency
            balance = updateService.getLocalBalanceFor(wallet: wallet, currency: currency)
            balanceRate = updateService.getLocalRate(for: currency)
        }
        
        let formattedValue = BigDecimalNumber(balance.valueWithDecimals).toFormattedCropNumber(multiplier: balanceRate,
                                                                                               precision: usdCurrency.decimals)
        
        return WalletBalanceRateEntity(rate: formattedValue, symbol: usdCurrency.symbol)
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
        let currency = ETHCurrency.ethCurrency
        
        rates = .none
        
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { [weak self] result in
            guard let self = self else {
                return
            }
            let entity: WalletEntity?
            switch result {
            case .success(let balance):
                let currency = Constants.ETHConstants.ETHSymbol
                entity = WalletEntity(
                    address: wallet.address,
                    balanceWithCurrency: self.mapAttributedStringForBalance(
                        symbol: currency,
                        symbolSize: 20,
                        amount: balance.valueWithDecimals.toFormattedCropNumber(),
                        amountSize: 34
                    ),
                    balanceWithCurrencyCompact: self.mapAttributedStringForBalance(
                        symbol: currency,
                        symbolSize: 12,
                        amount: balance.valueWithDecimals.toFormattedCropNumber(),
                        amountSize: 20
                    )
                )
                DispatchQueue.main.async { [weak self] in
                    self?.updateRate(balance: balance.valueWithDecimals, rate: .none)
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
        
        updateService.obtainRate(for: currency) { result in
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
            rates = getEmptyBalancesStoreModel()
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
    
    private func getEmptyBalancesStoreModel() -> WalletBalancesStoreModel {
        return WalletBalancesStoreModel(balance: .none, balanceRate: .none)
    }
    
    private func getEmptyEntity() -> WalletEntity {
        return WalletEntity(
            address: String(),
            balanceWithCurrency: NSAttributedString(),
            balanceWithCurrencyCompact: nil
        )
    }
}

extension WalletInteractor: ETHUpdateEventDelegate {
    func didUpdateBalance() {
        updateBalanceInfo()
    }
}

// MARK: AuthEventDelegate

extension WalletInteractor: AuthEventDelegate {
    func didNewWalletSelected() {
        output.didNewWalletSelected()
    }
    
    func didAuthCompleted() {
    }
}
