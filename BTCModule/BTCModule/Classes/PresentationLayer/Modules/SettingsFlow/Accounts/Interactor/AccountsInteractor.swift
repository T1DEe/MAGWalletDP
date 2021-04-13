//
//  AccountsAccountsInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import UIKit

class AccountsInteractor {
    weak var output: AccountsInteractorOutput!
    var authService: BTCAuthService!
    var infoService: BTCUpdateService!
    var settingsConfiguration: BTCSettingsConfiguration!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var authActionHandler: AuthEventActionHandler!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var networkFacade: BTCNetworkFacade!
    var notificationFacade: BTCNotificationFacade!
    
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
    
    func unsubscribeNotifications(_ wallet: BTCWallet) {
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
    
    private func updateLocalBalances(_ wallets: [BTCWallet]) {
        let balances = infoService.getLocalBalancesFor(wallets: wallets)
        let updatedBalances = convertBalances(balances: balances)
        updateModelWithBalances(updatedBalances)
    }

    private func updateBalances(_ wallets: [BTCWallet]) {
        infoService.updateWalletsBalances(wallets: wallets) { [weak self] result in
            switch result {
            case .success(let balances):
                guard let updatedBalances = self?.convertBalances(balances: balances) else {
                    return
                }
                self?.updateModelWithBalances(updatedBalances)
                DispatchQueue.main.async { [weak self] in
                    self?.output.modelUpdated()
                }
                
            case .failure:
                return
            }
        }
    }
    
    private func createModelWithoutBalances(_ wallets: [BTCWallet], currentWallet: BTCWallet) {
        let screenAccounts = wallets.map { wallet -> AccountsScreenAccountModel in
            let balance = self.getEmptyBalances()
            return AccountsScreenAccountModel(wallet: wallet,
                                              isCurrent: wallet == currentWallet,
                                              balance: balance)
        }
        
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func updateModelWithNewSelectedWallet(_ wallet: BTCWallet) {
        var screenAccounts = [AccountsScreenAccountModel]()
        for screenAccount in model.accounts {
            let currentNetwork = networkFacade.getCurrentNetwork()
            let updatedWallet = BTCWallet(address: screenAccount.wallet.address, network: currentNetwork)
            updatedWallet.isCurrent = screenAccount.wallet == wallet
            let newAccount = AccountsScreenAccountModel(wallet: updatedWallet,
                                                        isCurrent: screenAccount.wallet == wallet,
                                                        balance: screenAccount.balance)
            screenAccounts.append(newAccount)
        }
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func updateModelWithDeletedWallet(_ wallet: BTCWallet) {
        var screenAccounts = model.accounts
        screenAccounts.removeAll { $0.wallet == wallet }
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func updateModelWithBalances(_ balances: [BTCWallet: String]) {
        var screenAccounts = [AccountsScreenAccountModel]()
        for screenAccount in model.accounts {
            guard let balance = balances[screenAccount.wallet] else {
                continue
            }
            let symbol = Constants.BTCConstants.BTCSymbol
            let balanceString = mapAttributedString(amount: balance,
                                                    symbol: symbol)
            
            let newAccount = AccountsScreenAccountModel(wallet: screenAccount.wallet,
                                                        isCurrent: screenAccount.isCurrent,
                                                        balance: balanceString)
            screenAccounts.append(newAccount)
        }
        self.model = AccountsScreenModel(accounts: screenAccounts)
    }
    
    private func getEmptyBalances() -> NSAttributedString {
        let emptyBalance = mapAttributedString(amount: "0", symbol: Constants.BTCConstants.BTCSymbol)
        return emptyBalance
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
    
    private func satoshiToBTC(satoshi: String) -> String {
        return BigDecimalNumber(satoshi).powerOfMinusTen(BigDecimalNumber(Constants.BTCConstants.BTCDecimal))
    }
    
    private func convertBalances(balances: [BTCWallet: String]) -> [BTCWallet: String] {
        var updatedBalances = [BTCWallet: String]()
        for (key, value) in balances {
            updatedBalances[key] = satoshiToBTC(satoshi: value)
        }
        return updatedBalances
    }
    
    private func getErrorSnackBarModel(message: String) -> ButtonSnackBarModel {
        return ButtonSnackBarModel(isBlocker: false,
                                   isError: true,
                                   title: R.string.localization.accountsScreenSwitchOrDeleteErrorTitle(),
                                   message: message,
                                   centerButtonTitle: R.string.localization.errorOkButtonTitle())
    }
}
