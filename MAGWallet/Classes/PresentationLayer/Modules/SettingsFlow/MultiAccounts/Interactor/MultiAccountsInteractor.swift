//
//  MultiAccountsMultiAccountsInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class MultiAccountsInteractor {
    weak var output: MultiAccountsInteractorOutput!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var flowNotificationFacade: FlowNotificationFacade!
    
    var accountsHolders: [AccountInfo] = []
    var model: MultiAccountsScreenModel
    
    init() {
        model = MultiAccountsScreenModel(sections: [MultiAccountsScreenSectionModel]())
    }
}

// MARK: - MultiAccountsInteractorInput

extension MultiAccountsInteractor: MultiAccountsInteractorInput {
    func setAccountHolders(_ accountsHolders: [AccountInfo]) {
        self.accountsHolders = accountsHolders
    }
    
    func getScreenModel() -> MultiAccountsScreenModel {
        return model
    }
    
    func updateModel() {
        accountsHolders.forEach { updateModelByHolder($0) }
        output.modelUpdated()
    }
    
    func selectAccountAsCurrent(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo) {
        do {
            try accountsHolder.selectAccount(account.accountName)
            updateModelWithNewSelectedAccount(account.accountName, accountsHolder: accountsHolder)
            output.modelUpdated()
        } catch {
            let model = getErrorSnackBarModel(message: R.string.localization.accountsScreenSwitchErrorMessage())
            output.errorHandled(model: model)
        }
    }
    
    func deleteAccount(_ account: MultiAccountsScreenAccountModel, accountsHolder: AccountInfo) {
        guard let notifiableHolder = accountsHolder as? Notifiable else {
            return
        }
        
        do {
            try accountsHolder.deleteAccount(account.accountName)
            flowNotificationFacade.unsubscribeAddress(address: account.accountName, flow: notifiableHolder)
            updateModelWithDeletedAccount(account.accountName, accountsHolder: accountsHolder)
            if let selectedAccount = try? accountsHolder.obtainCurrentAccount() {
                updateModelWithNewSelectedAccount(selectedAccount, accountsHolder: accountsHolder)
            }
            output.modelUpdated()
        } catch {
            let model = getErrorSnackBarModel(message: R.string.localization.accountsScreenDeleteErrorMessage())
            output.errorHandled(model: model)
        }
    }
    
    func makeShowSnackBarEvent(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    // MARK: Private
    
    private func updateModelByHolder(_ accountsHolder: AccountInfo) {
        let headerModel = MultiAccountsScreenHeaderModel(title: accountsHolder.getAccountsTitle(), needButton: true)
        let screenAccounts: [MultiAccountsScreenAccountModel]
        
        if let accounts = try? accountsHolder.obtainAccounts(),
            let currentAccount = try? accountsHolder.obtainCurrentAccount() {
            let currency = accountsHolder.obtainWalletCurrency()
            let tokenCurrency = try? accountsHolder.obtainTokenCurrency()
            screenAccounts = accounts.map { account -> MultiAccountsScreenAccountModel in
                let balances = self.getEmptyBalances(currency: currency,
                                                     tokenCurrency: tokenCurrency)
                return MultiAccountsScreenAccountModel(accountName: account,
                                                       isCurrent: currentAccount == account,
                                                       balance: balances.balance,
                                                       tokentBalance: balances.tokenBalance)
            }
        } else {
            screenAccounts = [MultiAccountsScreenAccountModel]()
        }
        
        let sectionModel = MultiAccountsScreenSectionModel(headerModel: headerModel,
                                                           accounts: screenAccounts,
                                                           accountsHolder: accountsHolder)
        
        var sections = model.sections
        let index = sections.firstIndex { $0.accountsHolder.obtainWalletCurrency() == accountsHolder.obtainWalletCurrency() }
        if let index = index {
            sections[index] = sectionModel
        } else {
            sections.append(sectionModel)
        }
        
        self.model = MultiAccountsScreenModel(sections: sections)
        updateBalances(accountsHolder)
    }
    
    private func updateModelByHolder(_ accountsHolder: AccountInfo, balances: [String: String], currency: String) {
        var sections = model.sections
        let findedIndex = sections.firstIndex { $0.accountsHolder.obtainWalletCurrency() == accountsHolder.obtainWalletCurrency() }
        guard let index = findedIndex else {
            return
        }
        
        var screenAccounts = [MultiAccountsScreenAccountModel]()
        for screenAccount in sections[index].accounts {
            guard let balance = balances[screenAccount.accountName] else {
                continue
            }
            
            let balanceString = mapAttributedString(amount: balance,
                                                    symbol: currency)
            let isToken = currency != accountsHolder.obtainWalletCurrency()
            
            let newAccount = MultiAccountsScreenAccountModel(accountName: screenAccount.accountName,
                                                             isCurrent: screenAccount.isCurrent,
                                                             balance: isToken ? screenAccount.balance : balanceString,
                                                             tokentBalance: isToken ? balanceString : screenAccount.tokentBalance)
            screenAccounts.append(newAccount)
        }
        
        let sectionModel = MultiAccountsScreenSectionModel(headerModel: sections[index].headerModel,
                                                           accounts: screenAccounts,
                                                           accountsHolder: accountsHolder)

        sections[index] = sectionModel
        self.model = MultiAccountsScreenModel(sections: sections)
    }
    
    private func updateModelWithNewSelectedAccount(_ account: String, accountsHolder: AccountInfo) {
        var sections = model.sections
        let findedIndex = sections.firstIndex { $0.accountsHolder.obtainWalletCurrency() == accountsHolder.obtainWalletCurrency() }
        guard let index = findedIndex else {
            return
        }
        
        var screenAccounts = [MultiAccountsScreenAccountModel]()
        for screenAccount in sections[index].accounts {
            let newAccount = MultiAccountsScreenAccountModel(accountName: screenAccount.accountName,
                                                             isCurrent: screenAccount.accountName == account,
                                                             balance: screenAccount.balance,
                                                             tokentBalance: screenAccount.tokentBalance)
            screenAccounts.append(newAccount)
        }
        let sectionModel = MultiAccountsScreenSectionModel(headerModel: sections[index].headerModel,
                                                           accounts: screenAccounts,
                                                           accountsHolder: accountsHolder)

        sections[index] = sectionModel
        self.model = MultiAccountsScreenModel(sections: sections)
    }
    
    private func updateModelWithDeletedAccount(_ account: String, accountsHolder: AccountInfo) {
        var sections = model.sections
        let findedIndex = sections.firstIndex { $0.accountsHolder.obtainWalletCurrency() == accountsHolder.obtainWalletCurrency() }
        guard let index = findedIndex else {
            return
        }
        
        var screenAccounts = sections[index].accounts
        screenAccounts.removeAll { $0.accountName == account }
        
        let sectionModel = MultiAccountsScreenSectionModel(headerModel: sections[index].headerModel,
                                                           accounts: screenAccounts,
                                                           accountsHolder: accountsHolder)

        sections[index] = sectionModel
        self.model = MultiAccountsScreenModel(sections: sections)
    }
    
    private func updateBalances(_ accountsHolder: AccountInfo) {
        accountsHolder.obtainBalances { [weak self] result in
            switch result {
            case .success(let balancesMap):
                self?.updateModelByHolder(accountsHolder,
                                          balances: balancesMap,
                                          currency: accountsHolder.obtainWalletCurrency())
                DispatchQueue.main.async { [weak self] in
                    self?.output.modelUpdated()
                }
                
            case .failure:
                return
            }
        }
        
        accountsHolder.obtainTokenBalances { [weak self] result in
            switch result {
            case .success(let balancesMap):
                guard let token = try? accountsHolder.obtainTokenCurrency() else {
                    return
                }
                self?.updateModelByHolder(accountsHolder,
                                          balances: balancesMap,
                                          currency: token)
                DispatchQueue.main.async { [weak self] in
                    self?.output.modelUpdated()
                }
                
            case .failure:
                return
            }
        }
    }
    
    private func getEmptyBalances(currency: String, tokenCurrency: String?) -> (balance: NSAttributedString, tokenBalance: NSAttributedString?) {
        let balance = mapAttributedString(amount: "0", symbol: currency)
        var tokenBalance: NSAttributedString? = nil
        if let tokenCurrency = tokenCurrency {
            tokenBalance = mapAttributedString(amount: "0", symbol: tokenCurrency)
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
                                   centerButtonTitle: R.string.localization.buttonOk())
    }
}
