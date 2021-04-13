//
//  BTCNetworkAdapter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

enum BTCWalletMappedError: Swift.Error, Equatable {
    case operationError
    case invalidFormat
    case invalidData
}

protocol BTCNetworkAdapter {
    func balance(address: String, completion: @escaping ((Result<BTCWalletBalanceModel, BTCWalletMappedError>) -> Void))
    
    func sendRawTransaction(transactionHex: String,
                            completion: @escaping ((Result<Void, BTCWalletMappedError>) -> Void))
    
    func history(address: String, skip: Int?, limit: Int?,
                 completion: @escaping ((Result<BTCPagedResponse<BTCWalletHistoryModel>, BTCWalletMappedError>) -> Void))
    
    func unspentOutputs(address: String,
                        completion: @escaping ( (Result<[BTCWalletOutputModel], BTCWalletMappedError>) -> Void))
    
    func getFeePerKb(completion: @escaping ((Result<String, BTCWalletMappedError>) -> Void))
    
    func rate(completion: @escaping (Result<BTCCoinRateModel, BTCWalletMappedError>) -> Void)
    func rateHistory(completion: @escaping (Result<[BTCCoinHistoryRateModel], BTCWalletMappedError>) -> Void)
    
    func subscribeToPushNotifications(addresses: [String],
                                      firebaseToken: String,
                                      types: [BTCNotificationType],
                                      completion: @escaping (() throws -> (BTCNotificationModel)) -> Void)
    func unsubscribePushNotifications(addresses: [String],
                                      firebaseToken: String,
                                      types: [BTCNotificationType],
                                      completion: @escaping (() throws -> (BTCNotificationModel)) -> Void)
}
