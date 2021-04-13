//
//  LTCUpdateService.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum LTCUpdateError: Error {
    case connectionFailed
    case mappingError
}

typealias LTCUpdateCompletionHandler<T> = (_ result: Result<T, LTCUpdateError>) -> Void

protocol LTCUpdateService: LTCNetworkConfigurable {
    func getLocalBalanceFor(wallet: LTCWallet) -> String
    func getLocalBalancesFor(wallets: [LTCWallet]) -> [LTCWallet: String]
    func updateWalletBalance(wallet: LTCWallet, completion: LTCUpdateCompletionHandler<String>?)
    func updateWalletsBalances(wallets: [LTCWallet], completion: LTCUpdateCompletionHandler<[LTCWallet: String]>?)
    func obtainWalletHistory(
        wallet: LTCWallet,
        skip: Int?,
        limit: Int?,
        completion: @escaping LTCUpdateCompletionHandler<LTCPagedResponse<LTCWalletHistoryModel>>
    )
    func obtainRate(completion: @escaping LTCUpdateCompletionHandler<LTCCoinRateModel>)
    func getLocalRate() -> String
    func obtainRatesHistory(completion: @escaping LTCUpdateCompletionHandler<[LTCCoinHistoryRateModel]>)
}
