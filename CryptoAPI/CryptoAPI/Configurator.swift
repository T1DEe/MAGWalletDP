//
//  Configurator.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final public class Configurator {
    public var workingQueue: DispatchQueue = DispatchQueue.main
    public var timeoutIntervalForRequest: TimeInterval = 15
    public var timeoutIntervalForResource: TimeInterval = 15
    public var sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
    public var networkType: NetworkType = .mainnet
    public var debugEnabled: Bool = false
}
