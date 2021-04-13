//
//  RatesServiceImp.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class RatesServiceImp: RatesService {
    let networkAdapter: RatesNetworkAdapter
    
    public init(networkAdapter: RatesNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
    
    func rates(coins: [CryptoCurrencyType], completion: @escaping (Result<[RatesResponseModel], CryptoApiError>) -> Void) {
        networkAdapter.rates(coins: coins.map { $0.rawValue }, completion: completion)
    }
    
    func ratesHistory(coins: [CryptoCurrencyType], completion: @escaping (Result<[RatesHistoryResponseModel], CryptoApiError>) -> Void) {
        networkAdapter.ratesHistory(coins: coins.map { $0.rawValue }, completion: completion)
    }
}
