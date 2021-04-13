//
//  LTCNetworkAdapter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

enum LTCWalletMappedError: Swift.Error, Equatable {
    case operationError
    case invalidFormat
    case invalidData
}

protocol LTCNetworkAdapter {
    func balance(address: String, completion: @escaping ((Result<LTCWalletBalanceModel, LTCWalletMappedError>) -> Void))
    
    func sendRawTransaction(transactionHex: String,
                            completion: @escaping ((Result<Void, LTCWalletMappedError>) -> Void))
    
    func history(address: String, skip: Int?, limit: Int?,
                 completion: @escaping ((Result<LTCPagedResponse<LTCWalletHistoryModel>, LTCWalletMappedError>) -> Void))
    
    func unspentOutputs(address: String,
                        completion: @escaping ( (Result<[LTCWalletOutputModel], LTCWalletMappedError>) -> Void))
    
    func getFeePerKb(completion: @escaping ((Result<String, LTCWalletMappedError>) -> Void))
    
    func rate(completion: @escaping (Result<LTCCoinRateModel, LTCWalletMappedError>) -> Void)
    func rateHistory(completion: @escaping (Result<[LTCCoinHistoryRateModel], LTCWalletMappedError>) -> Void)
    
    func subscribeToPushNotifications(addresses: [String],
                                      firebaseToken: String,
                                      types: [LTCNotificationType],
                                      completion: @escaping (() throws -> (LTCNotificationModel)) -> Void)
    func unsubscribePushNotifications(addresses: [String],
                                      firebaseToken: String,
                                      types: [LTCNotificationType],
                                      completion: @escaping (() throws -> (LTCNotificationModel)) -> Void)
}
