//
//  ETHUpdateFacade.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//
import SharedFilesModule

enum ETHUpdateError: Swift.Error, Equatable {
    /// Indicates that connection to the server failed
    case connectionFaild
    
    /// Indicates that wallet doesnt exist
    case walletDoesntExist
    
    /// Indicates error inside framework
    case mappingError
}

typealias ETHUpdateCompletionHadler<T> = (_ result: Result<T, ETHUpdateError>) -> Void

protocol ETHUpdateService: ETHNetworkConfigurable {
    func getLocalBalanceFor(wallet: ETHWallet, currency: Currency) -> Amount
    func getLocalBalancesFor(wallets: [ETHWallet], currency: Currency) -> [ETHWallet: Amount]
    func updateWalletBalance(wallet: ETHWallet,
                             currency: Currency,
                             completion: ETHUpdateCompletionHadler<Amount>?)
    
    func updateWalletsBalances(wallets: [ETHWallet],
                               currency: Currency,
                               completion: ETHUpdateCompletionHadler<[ETHWallet: Amount]>?)
    
    //obtain history from server without storing anywhere
    func obtainWalletHistory(wallet: ETHWallet,
                             currency: Currency,
                             from: Int?,
                             limit: Int?,
                             completion: @escaping ETHUpdateCompletionHadler<ETHPagedResponse<ETHWalletHistoryEntity>>)
    
    //obtain token history from server without storing anywhere
    func obtainTokenHistory(wallet: ETHWallet,
                            currency: Currency,
                            from: Int?,
                            limit: Int?,
                            completion: @escaping ETHUpdateCompletionHadler<ETHPagedResponse<ETHWalletTokenHistoryEntity>>)
    
    func obtainRate(for currency: Currency, completion: @escaping ETHUpdateCompletionHadler<ETHCoinRateModel>)
    func getLocalRate(for currency: Currency) -> String
    func obtainRatesHistory(for currency: Currency, completion: @escaping ETHUpdateCompletionHadler<[ETHCoinHistoryRateModel]>)
}
