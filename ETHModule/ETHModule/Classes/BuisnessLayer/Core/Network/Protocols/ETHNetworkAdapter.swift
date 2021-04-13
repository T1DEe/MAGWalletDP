//
//  ETHNetworkAdapter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoAPI
import Foundation

enum ETHWalletMapError: Swift.Error, Equatable {
    /// Indicates that date is invalid format
    case invalidFormat
}

protocol ETHNetworkAdapter: class {
    func history(address: String,
                 from: Int?,
                 limit: Int?,
                 completion: @escaping (() throws -> (ETHPagedResponse<ETHWalletHistoryEntity>)) -> Void)
    
    func tokenHistory(tokenAddress: String,
                      address: String,
                      from: Int?,
                      limit: Int?,
                      completion: @escaping (() throws -> (ETHPagedResponse<ETHWalletTokenHistoryEntity>)) -> Void)
    
    func balance(address: String,
                 completion: @escaping (() throws -> (ETHWalletBalanceModel)) -> Void)
    
    func tokenBalance(address: String,
                      tokenAddress: String,
                      completion: @escaping (() throws -> (ETHWalletBalanceModel)) -> Void)
    
    func sendRawTransaction(transaction: String,
                            completion: @escaping (() throws -> Void) -> Void)
    
    func estimateGas(from: String,
                     to: String,
                     value: String,
                     data: String,
                     completion: @escaping (() throws -> (EtherEstimatesModel)) -> Void)
    
    func rate(coin: CryptoCurrencyType, completion: @escaping (() throws -> (ETHCoinRateModel)) -> Void)
    func rateHistory(coin: CryptoCurrencyType, completion: @escaping (() throws -> ([ETHCoinHistoryRateModel])) -> Void)
    
    func subscribeToPushNotifications(addresses: [String],
                                      firebaseToken: String,
                                      types: [ETHNotificationType],
                                      completion: @escaping (() throws -> (ETHNotificationModel)) -> Void)
    func unsubscribePushNotifications(addresses: [String],
                                      firebaseToken: String,
                                      types: [ETHNotificationType],
                                      completion: @escaping (() throws -> (ETHNotificationModel)) -> Void
    )
}
