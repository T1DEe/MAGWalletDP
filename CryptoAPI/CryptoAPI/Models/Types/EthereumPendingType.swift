//
//  EthereumPendingType.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

/// Ethereum pending transaction's parameter
public enum EthereumPendingType: String, Codable {
    /// Include pending transactions
    case include
    
    /// Not include pending transactions
    case exclude
    
    /// Only pending transactions
    case only
}
