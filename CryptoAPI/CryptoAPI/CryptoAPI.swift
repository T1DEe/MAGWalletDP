//
//  CryptoAPI.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public final class CryptoAPI {
    public let eth: ETHService
    public let bch: BCHService
    public let btc: BTCService
    public let ltc: LTCService
    public let common: CommonService
    public let rates: RatesService
    
    public init(settings: Settings) {
        let configuration = settings.sessionConfiguration
        configuration.timeoutIntervalForRequest = settings.timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = settings.timeoutIntervalForResource
        
        let urlSession = URLSession(configuration: configuration)
        let authorizationToken = settings.authorizationToken
        
        let ethNetworkAdapter = ETHNetworkAdapterImp(
            session: urlSession,
            baseUrl: settings.getBaseUrlString(),
            authToken: authorizationToken,
            needLogs: settings.debugEnabled
        )
        let btcNetworkAdapter = BTCNetworkAdapterImp(
            session: urlSession,
            baseUrl: settings.getBaseUrlString(),
            authToken: authorizationToken,
            needLogs: settings.debugEnabled
        )
        let bchNetworkAdapter = BCHNetworkAdapterImp(
            session: urlSession,
            baseUrl: settings.getBaseUrlString(),
            authToken: authorizationToken,
            needLogs: settings.debugEnabled
        )
        let ltcNetworkAdapter = LTCNetworkAdapterImp(
            session: urlSession,
            baseUrl: settings.getBaseUrlString(),
            authToken: authorizationToken,
            needLogs: settings.debugEnabled
        )
        let commonNetworkAdapter = CommonNetworkAdapterImp(
            session: urlSession,
            baseUrl: settings.getBaseUrlString(),
            authToken: authorizationToken,
            needLogs: settings.debugEnabled
        )
        let ratesNetworkAdapter = RatesNetworkAdapterImp(
            session: urlSession,
            baseUrl: settings.getBaseUrlString(),
            authToken: authorizationToken,
            needLogs: settings.debugEnabled
        )
        
        let ethService = ETHServiceImp(networkAdapter: ethNetworkAdapter)
        let btcService = BTCServiceImp(networkAdapter: btcNetworkAdapter)
        let bchService = BCHServiceImp(networkAdapter: bchNetworkAdapter)
        let ltcService = LTCServiceImp(networkAdapter: ltcNetworkAdapter)
        let commonService = CommonServiceImp(networkAdapter: commonNetworkAdapter)
        let ratesService = RatesServiceImp(networkAdapter: ratesNetworkAdapter)
        
        bch = bchService
        eth = ethService
        btc = btcService
        ltc = ltcService
        common = commonService
        rates = ratesService
    }
}
