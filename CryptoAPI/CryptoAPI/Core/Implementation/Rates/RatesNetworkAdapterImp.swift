//
//  RatesNetworkAdapterImp.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class RatesNetworkAdapterImp: RatesNetworkAdapter {
    let session: URLSession
    let baseUrl: String
    let authToken: String
    let needLogs: Bool
    
    init(session: URLSession, baseUrl: String, authToken: String, needLogs: Bool) {
        self.session = session
        self.baseUrl = baseUrl
        self.authToken = authToken
        self.needLogs = needLogs
    }
    
    func rates(coins: [String], completion: @escaping (Result<[RatesResponseModel], CryptoApiError>) -> Void) {
        RatesNetwork.rates(coins: coins)
            .request(type: [RatesResponseModel].self, session: session, baseUrl: baseUrl,
                     authToken: authToken, withLog: needLogs, completionHandler: completion)
    }
    
    func ratesHistory(coins: [String], completion: @escaping (Result<[RatesHistoryResponseModel], CryptoApiError>) -> Void) {
        RatesNetwork.ratesHistory(coins: coins)
        .request(type: [RatesHistoryResponseModel].self, session: session, baseUrl: baseUrl,
                 authToken: authToken, withLog: needLogs, completionHandler: completion)
    }
}
