//
//  LTCTransferService.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

enum LTCTransferError: Swift.Error, Equatable {
    case invalidSeed
    case invalidInputs
    case networkParams
    case signTx
    case sendFailure
    case notEnoughMoney
    case getUnspentOutputs
    case createTX
    case feeEstimating
}

protocol LTCTransferService: LTCNetworkConfigurable {
    func isValidAddress(_ address: String) -> Bool
    
    func send(seed: String,
              toAddress: String,
              amount: String,
              completion: @escaping (Result<Void, LTCTransferError>) -> Void)
    
    func estimate(fromAddress: String,
                  amount: String,
                  completion: @escaping ((Result<Int, LTCTransferError>) -> Void) )
}
