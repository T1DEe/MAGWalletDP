//
//  AccountsAccountsInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import UIKit

class AccountsInteractor {
    weak var output: AccountsInteractorOutput!
    var authService: ETHAuthService!
    var infoService: ETHUpdateService!
    var settingsConfiguration: ETHSettingsConfiguration!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var authActionHandler: AuthEventActionHandler!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var networkFacade: ETHNetworkFacade!
    var notificationFacade: ETHNotificationFacade!
    
    var model: AccountsScreenModel
    
    init() {
        self.model = AccountsScreenModel(accounts: [AccountsScreenAccountModel]())
    }
}

// MARK: - AccountsInteractorInput

extension AccountsInteractor: AccountsInteractorInput {
    func getScreenModel() -> AccountsScreenModel {
        return model
    }
    
    func updateModel() {
        guard let currentWallet = try? authService.getCurrentWallet() else {
            return
        }
        
        guard let wallets = try? authService.getWallets() else {
            return
        }
        
        createModelWithoutBalances(wallets, currentWallet: currentWallet)
        updateLocalBalances(wallets)
        updateBalances(wallets)
    }
    
    func selectAccountAsCurrent(_ account: AccountsScreenAccountModel) {
        do {
            try authService.selectWallet(account.wallet)
            authActionHandler.actionNewWalletSelected()
            updateModelWithNewSelectedWallet(account.wallet)
            output.modelUpdated()
        } catch {
            let model = getErrorSnackBarModel(message: R.string.localization.accountsScreenSwitchErrorMessage())
            output.errorHandled(model: model)
        }
    }
    
    func deleteAccount(_ account: AccountsScreenAccountModel) {
        let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: account.wallet)
        let command = SecureDataRemoveCommand(key: key) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success:
                do {
                    try strongSelf.authService.deleteWallet(account.wallet)
                    self?.updateModelWithDeletedWallet(account.wallet)
                    if let newSelectedWallet = try? self?.authService.getCurrentWallet() {
                        self?.updateModelWithNewSelectedWallet(newSelectedWallet)
                    }
                    self?.output.modelUpdated()
                    self?.authActionHandler.actionNewWalletSelected()
                    
                    if !strongSelf.authService.hasWallets {
                        strongSelf.output.didLogout()
                    }
                } catch {
                    let model = strongSelf.getErrorSnackBarModel(message: R.string.localization.accountsScreenDeleteErrorMessage())
                    strongSelf.output.errorHandled(model: model)
                }

            case .failure:
                let model = strongSelf.getErrorSnackBarModel(message: R.string.localization.accountsScreenDeleteErrorMessage())
                strongSelf.output.errorHandled(model: model)
            }
        }
        sensitiveDataActionHandler.processCommand(command)
    }
    
    func unsubscribeNotifications(_ wallet: ETHWallet) {
        notificationFacade.unsubscribeWallet(wallet) { result in
            switch result {
            case .success:
                print("Successfully unsubscribed from \(wallet.address)")
                
            case .failure:
                print("Failed to unsubscribe \(wallet.address)")
            }
        }
    }
    
    func makeShowSnackBarEvent(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }

    // MARK: Private
    
    private func updateLocalBalances(_ wallets: [ETHWallet]) {
        let currency = ETHCurrency.ethCurrency
        let balances = infoService.getLocalBalancesFor(wallets: wallets,
                                                       currency: currency)
        updateModelWithBalances(balances, currency: currency)
        
        if let tokenCurrency = settingsConfiguration.additionalToken {
            let tokenBalances = infoService.getLocalBalancesFor(wallets: wallets, currency: tokenCurrency)
            updateModelWithBalances(tokenBalances, currency: tokenCurrency)
        }
    }
    
    private func updateBalances(_ wallets: [ETHWallet]) {
        updateBalances(wallets, currency: ETHCurrency.ethCurrency)
        if let tokenCurrency = settingsConfiguration.additionalToken {
            updateBalances(wallets, currency: tokenCurrency)
        }
    }
    
    private func updateBalances(_ wallets: [ETHWallet], currency: Currency) {
        infoService.updateWalletsBalances(wallets: wallets, currency: currency) { [weak self] result in
            switch result {
            case .success(let balancesMap):
                self?.updateModelWithBalances(balancesMap, currency: currency)
                DispatchQueue.main.async { [weak self] in
                    self?.output.modelUpdated()
                }
                
            case .failure:
                return
            }
        }
    }
    
    private func createModelWithoutBalances(_ wallets: [ETHWallet], currentWallet: ETHWallet) {
        let screenAccounts = wallets.map { wallet -> AccountsScreenAccountModel in
            let balances = self.getEmptyBalances()
            return AccountsScreenAccountModel(wallet: wallet,
                                              isCurrent: wallet == currentWallet,
                                              balance: balances.balance,
                                              tokentBalance: balances.tokenBalance)
        }
        
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func updateModelWithNewSelectedWallet(_ wallet: ETHWallet) {
        var screenAccounts = [AccountsScreenAccountModel]()
        let currentNetwork = networkFacade.getCurrentNetwork()
        for screenAccount in model.accounts {
            let updatedWallet = ETHWallet(address: screenAccount.wallet.address, network: currentNetwork)
            updatedWallet.isCurrent = screenAccount.wallet == wallet
            let newAccount = AccountsScreenAccountModel(wallet: updatedWallet,
                                                        isCurrent: screenAccount.wallet == wallet,
                                                        balance: screenAccount.balance,
                                                        tokentBalance: screenAccount.tokentBalance)
            screenAccounts.append(newAccount)
        }
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func updateModelWithDeletedWallet(_ wallet: ETHWallet) {
        var screenAccounts = model.accounts
        screenAccounts.removeAll { $0.wallet == wallet }
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func updateModelWithBalances(_ balances: [ETHWallet: Amount], currency: Currency) {
        var screenAccounts = [AccountsScreenAccountModel]()
        for screenAccount in model.accounts {
            guard let balance = balances[screenAccount.wallet] else {
                continue
            }
            
            let balanceString = mapAttributedString(amount: balance.valueWithDecimals.toFormattedCropNumber(),
                                                    symbol: currency.symbol)
            let isToken = currency.id != ETHCurrency.ethCurrency.id
            
            let newAccount = AccountsScreenAccountModel(wallet: screenAccount.wallet,
                                                        isCurrent: screenAccount.isCurrent,
                                                        balance: isToken ? screenAccount.balance : balanceString,
                                                        tokentBalance: isToken ? balanceString : screenAccount.tokentBalance)
            screenAccounts.append(newAccount)
        }
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func getEmptyBalances() -> (balance: NSAttributedString, tokenBalance: NSAttributedString?) {
        let balance = mapAttributedString(amount: "0", symbol: ETHCurrency.ethCurrency.symbol)
        var tokenBalance: NSAttributedString? = nil
        if let token = settingsConfiguration.additionalToken {
            tokenBalance = mapAttributedString(amount: "0", symbol: token.symbol)
        }
        
        return (balance, tokenBalance)
    }
    
    private func mapAttributedString(amount: String, symbol: String) -> NSAttributedString {
        let amount = NSMutableAttributedString(
            string: amount + " ",
            attributes: [
              .font: R.font.poppinsMedium(size: 12.0) ?? UIFont.systemFont(ofSize: 12),
              .foregroundColor: R.color.dark() ?? UIColor.black,
              .kern: 0.3
            ]
        )

        let symbolAttributed = NSMutableAttributedString(
            string: symbol,
            attributes: [
                .font: R.font.poppinsMedium(size: 12.0) ?? UIFont.systemFont(ofSize: 12),
                .foregroundColor: R.color.gray1() ?? UIColor.black,
                .kern: 0.3
            ]
        )
        amount.append(symbolAttributed)

        return amount
    }
    
    private func getErrorSnackBarModel(message: String) -> ButtonSnackBarModel {
        return ButtonSnackBarModel(isBlocker: false,
                                   isError: true,
                                   title: R.string.localization.accountsScreenSwitchOrDeleteErrorTitle(),
                                   message: message,
                                   centerButtonTitle: R.string.localization.errorOkButtonTitle())
    }
}
