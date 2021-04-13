//
//  BTCUpdateService.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum BTCUpdateError: Error {
    case connectionFailed
    case mappingError
}

typealias BTCUpdateCompletionHandler<T> = (_ result: Result<T, BTCUpdateError>) -> Void

protocol BTCUpdateService: BTCNetworkConfigurable {
    func getLocalBalanceFor(wallet: BTCWallet) -> String
    func getLocalBalancesFor(wallets: [BTCWallet]) -> [BTCWallet: String]
    func updateWalletBalance(wallet: BTCWallet, completion: BTCUpdateCompletionHandler<String>?)
    func updateWalletsBalances(wallets: [BTCWallet], completion: BTCUpdateCompletionHandler<[BTCWallet: String]>?)
    func obtainWalletHistory(
        wallet: BTCWallet,
        skip: Int?,
        limit: Int?,
        completion: @escaping BTCUpdateCompletionHandler<BTCPagedResponse<BTCWalletHistoryModel>>
    )
    func obtainRate(completion: @escaping BTCUpdateCompletionHandler<BTCCoinRateModel>)
    func getLocalRate() -> String
    func obtainRatesHistory(completion: @escaping BTCUpdateCompletionHandler<[BTCCoinHistoryRateModel]>)
}
