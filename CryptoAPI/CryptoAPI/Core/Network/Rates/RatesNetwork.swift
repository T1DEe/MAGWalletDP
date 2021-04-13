//
//  RatesNetwork.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum RatesNetwork: Resty {
    case rates(coins: [String])
    case ratesHistory(coins: [String])
}

extension RatesNetwork {
    var path: String {
        switch self {
        case .rates(let coins):
            return "rates/\(coins.description)"
            
        case .ratesHistory(coins: let coins):
            return "rates/\(coins.description)/history"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
