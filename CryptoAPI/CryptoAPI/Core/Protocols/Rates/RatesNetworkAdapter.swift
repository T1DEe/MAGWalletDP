//
//  RatesNetworkAdapter.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol RatesNetworkAdapter {
    func rates(coins: [String], completion: @escaping (Result<[RatesResponseModel], CryptoApiError>) -> Void)
    func ratesHistory(coins: [String], completion: @escaping (Result<[RatesHistoryResponseModel], CryptoApiError>) -> Void)
}
