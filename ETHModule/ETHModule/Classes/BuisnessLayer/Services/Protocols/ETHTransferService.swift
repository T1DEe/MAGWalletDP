//
//  ETHTransferService.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//
import BigInt
import SharedFilesModule

enum ETHTransferError: Swift.Error, Equatable {
    case invalidSeed
    case invalidInputs
    case networkParams
    case signTx
    case sendFailure
    case notEnoughMoney
}

typealias ETHTransferCompletionHndler<T> = (_ result: Result<T, ETHTransferError>) -> Void
typealias ETHTransferEstimates = (estimateGas: BigUInt, gasPrice: BigUInt, nonce: BigUInt, fee: BigUInt)

protocol ETHTransferService: ETHNetworkConfigurable {
    func isValidAddress(_ address: String) -> Bool
    func send(seed: String, toAddress: String, amount: String, currency: Currency,
              completion: @escaping ETHTransferCompletionHndler<Any>)
    func estimate(fromAddress: String, toAddress: String, amount: String, currency: Currency,
                  completion: @escaping ETHTransferCompletionHndler<ETHTransferEstimates>)
}
