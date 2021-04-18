//
//  Settings.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final public class Settings {
    public let authorizationToken: String
    public var workingQueue: DispatchQueue
    public var timeoutIntervalForRequest: TimeInterval
    public var timeoutIntervalForResource: TimeInterval
    public var sessionConfiguration: URLSessionConfiguration
    public var networkType: NetworkType
    public var debugEnabled: Bool
    
    public typealias BuildConfiguratorClosure = (Configurator) -> Void
    
    public init(authorizationToken: String, build: BuildConfiguratorClosure = { _ in }) {
        self.authorizationToken = authorizationToken
        
        let configurator = Configurator()
        build(configurator)
        timeoutIntervalForResource = configurator.timeoutIntervalForResource
        timeoutIntervalForRequest = configurator.timeoutIntervalForRequest
        sessionConfiguration = configurator.sessionConfiguration
        workingQueue = configurator.workingQueue
        networkType = configurator.networkType
        debugEnabled = configurator.debugEnabled
    }
    
    public func getBaseUrlString() -> String {
        switch networkType {
        case .mainnet:
            return Constants.mainnetUrl
            
        case .testnet:
            return Constants.testnetUrl
        }
    }
}
