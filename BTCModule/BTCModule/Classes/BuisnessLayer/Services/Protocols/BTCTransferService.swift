//
//  BTCTransferService.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

//import BigInt
import SharedFilesModule

enum BTCTransferError: Swift.Error, Equatable {
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

protocol BTCTransferService: BTCNetworkConfigurable {
    func isValidAddress(_ address: String) -> Bool
    
    func send(seed: String,
              toAddress: String,
              amount: String,
              completion: @escaping (Result<Void, BTCTransferError>) -> Void)
    
    func estimate(fromAddress: String,
                  amount: String,
                  completion: @escaping ((Result<Int, BTCTransferError>) -> Void) )
}
