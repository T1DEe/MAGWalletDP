//
//  RatesService.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol RatesService {
    /**
     Returns the latest market quote for 1 or more cryptocurrencies.
     - Parameter coins: Supported coins: BTC, ETH, BCH, OMG, RNT, PST, REP, ITC, KNC, BZNT, ZIL, ZRX, TRV
     - Parameter completion: Callback which returns an [RatesResponseModel](RatesResponseModel) result or error
     */
    func rates(coins: [CryptoCurrencyType], completion: @escaping (Result<[RatesResponseModel], CryptoApiError>) -> Void)
    
    /**
     Return required coins rates history last 30 days by fiat currencies.
     - Parameter coins: Supported coins: BTC, ETH, BCH, OMG, RNT, PST, REP, ITC, KNC, BZNT, ZIL, ZRX, TRV
     - Parameter completion: Callback which returns an [RatesHistoryResponseModel](RatesHistoryResponseModel) result or error
     */
    func ratesHistory(coins: [CryptoCurrencyType], completion: @escaping (Result<[RatesHistoryResponseModel], CryptoApiError>) -> Void)
}
