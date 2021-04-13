//
//  ETHTransferServiceImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BigInt
import BigNumber
import SharedFilesModule
import web3swift

final class ETHTransferServiceImp: ETHTransferService {
    var ethCoreComponent: ETHCoreComponent!
    var networkAdapter: ETHNetworkAdapter!
    var bytecodeCoreComponent: BytecodeCoreComponent!
    var currentNetwork: ETHNetworkType!
    
    private let semaphore = DispatchSemaphore(value: 0)
    
    private let workingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func isValidAddress(_ address: String) -> Bool {
        if let _ = try? self.getAddressFromString(address) {
            return true
        }
        
        return false
    }
    
    func send(seed: String, toAddress: String, amount: String,
              currency: Currency, completion: @escaping ETHTransferCompletionHndler<Any>) {
        if currency.isToken {
            sendToken(seed: seed, toAddress: toAddress, tokenAddress: currency.id,
                      tokenAmount: amount, currency: currency,
                      network: currentNetwork, completion: completion)
        } else {
            sendAmount(seed: seed, toAddress: toAddress, amount: amount, network: currentNetwork, completion: completion)
        }
    }
    
    func estimate(fromAddress: String, toAddress: String, amount: String, currency: Currency,
                  completion: @escaping ETHTransferCompletionHndler<ETHTransferEstimates>) {
        if currency.isToken {
            estimateSendToken(fromAddress: fromAddress, toAddress: toAddress,
                              amount: amount, currency: currency, completion: completion)
        } else {
            estimateSendAmount(fromAddress: fromAddress, toAddress: toAddress, amount: amount, completion: completion)
        }
    }
    
    private func sendToken(seed: String, toAddress: String, tokenAddress: String, tokenAmount: String, currency: Currency,
                           network: ETHNetworkType, completion: @escaping ETHTransferCompletionHndler<Any>) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                guard self.isValidAddress(toAddress) else {
                    throw ETHTransferError.invalidInputs
                }
                let amount = "0"
                let keystore = try self.getKeystoreFromSeed(seed)
                let addressString = self.ethCoreComponent.getAddress(keystore: keystore)
                let toETHAddress = try self.getAddressFromString(tokenAddress)
                let ethAmountString = try self.convertAmount(value: amount).1
                let ethAmount = try self.convertAmount(value: amount).0
                let tokenAmount = try self.convertAmount(value: tokenAmount).1
                let bytecode = try self.getBytecode(address: toAddress, value: tokenAmount)
                let networkParams = try self.getETHNetworkInfo(fromAddress: addressString,
                                                               toAddress: tokenAddress,
                                                               value: amount,
                                                               data: bytecode.hex)
                let fee = try self.convertBigNumInString(value: networkParams.fee)
                guard self.getIsEnoughAmount(address: addressString, amount: ethAmountString, fee: fee),
                    self.getIsEnoughtTokenAmount(address: addressString, tokenAddress: tokenAddress, amount: tokenAmount) else {
                    throw ETHTransferError.notEnoughMoney
                }
                var transaction = try self.createTokenTranscation(nonce: networkParams.nonce,
                                                                  gasLimit: networkParams.estimateGas,
                                                                  gasPrice: networkParams.gasPrice,
                                                                  toAddress: toETHAddress,
                                                                  data: bytecode.data,
                                                                  value: ethAmount)
                
                let txString = try self.signTransaction(transaction: &transaction, keystore: keystore)
                try self.sendTransaction(txString: txString)
                completion(.success(true))
            } catch let error as ETHTransferError {
                completion(.failure(error))
            } catch {
                completion(.failure(.sendFailure))
            }
        }
        workingQueue.addOperation(operation)
    }
    
    private func sendAmount(seed: String, toAddress: String, amount: String,
                            network: ETHNetworkType, completion: @escaping ETHTransferCompletionHndler<Any>) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                let keystore = try self.getKeystoreFromSeed(seed)
                let addressString = self.ethCoreComponent.getAddress(keystore: keystore)
                let toETHAddress = try self.getAddressFromString(toAddress)
                let ethAmountString = try self.convertAmount(value: amount).1
                let ethAmount = try self.convertAmount(value: amount).0
                let networkParams = try self.getETHNetworkInfo(fromAddress: addressString,
                                                               toAddress: toAddress,
                                                               value: ethAmountString)
                let fee = try self.convertBigNumInString(value: networkParams.fee)
                guard self.getIsEnoughAmount(address: addressString, amount: ethAmountString, fee: fee) else {
                    throw ETHTransferError.notEnoughMoney
                }
                var transaction = try self.createTranscation(nonce: networkParams.nonce,
                                                             gasLimit: networkParams.estimateGas,
                                                             gasPrice: networkParams.gasPrice,
                                                             toAddress: toETHAddress,
                                                             value: ethAmount)
                
                let txString = try self.signTransaction(transaction: &transaction, keystore: keystore)
                try self.sendTransaction(txString: txString)
                completion(.success(true))
            } catch let error as ETHTransferError {
                completion(.failure(error))
            } catch {
                completion(.failure(.sendFailure))
            }
        }
        workingQueue.addOperation(operation)
    }
    
    private func estimateSendAmount(fromAddress: String, toAddress: String, amount: String,
                                    completion: @escaping ETHTransferCompletionHndler<ETHTransferEstimates>) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                let ethAmountString = try self.convertAmount(value: amount).1
                let networkParams = try self.getETHNetworkInfo(fromAddress: fromAddress,
                                                               toAddress: toAddress,
                                                               value: ethAmountString)

                completion(.success(networkParams))
            } catch let error as ETHTransferError {
                completion(.failure(error))
            } catch {
                completion(.failure(.sendFailure))
            }
        }
        workingQueue.addOperation(operation)
    }
    
    private func estimateSendToken(fromAddress: String, toAddress: String, amount: String, currency: Currency,
                                   completion: @escaping ETHTransferCompletionHndler<ETHTransferEstimates>) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                let toTokenAddress = currency.id
                let ethAmountString = "0"
                let tokenAmount = try self.convertAmount(value: amount)
                var tokenAmountString = tokenAmount.1
                if tokenAmount.0 == BigUInt(0) {
                    tokenAmountString = "1"
                }
                let bytecode = try self.getBytecode(address: toAddress, value: tokenAmountString)
                let networkParams = try self.getETHNetworkInfo(fromAddress: fromAddress,
                                                               toAddress: toTokenAddress,
                                                               value: ethAmountString,
                                                               data: bytecode.hex)

                completion(.success(networkParams))
            } catch let error as ETHTransferError {
                completion(.failure(error))
            } catch {
                completion(.failure(.sendFailure))
            }
        }
        workingQueue.addOperation(operation)
    }
    
    private func getKeystoreFromSeed(_ seed: String) throws -> BIP32Keystore {
        guard let keystore = try? ethCoreComponent.createKeystore(seed: seed) else {
            throw ETHTransferError.invalidSeed
        }
        return keystore
    }
    
    private func getAddressFromString(_ addressString: String) throws -> web3swift.Address {
        let address = Address(addressString)
        guard address.isValid else {
            throw ETHTransferError.invalidInputs
        }
        return address
    }
    
    private func convertInBigNum(value: String) throws -> BigUInt {
        guard let number = BigUInt(value) else {
            throw ETHTransferError.invalidInputs
        }
        return number
    }
    
    private func convertBigNumInString(value: BigUInt) throws -> String {
        return value.string(unitDecimals: 0)
    }
    
    private func convertAmount(value: String) throws -> (BigUInt, String) {
        guard let resultUint = BigUInt(value) else {
            throw ETHTransferError.invalidInputs
        }
        return (resultUint, resultUint.string(unitDecimals: 0))
    }
    
    private func getIsEnoughAmount(address: String, amount: String, fee: String) -> Bool {
        guard let amountNumber = BigUInt(amount), let feeNumber = BigUInt(fee) else {
            return false
        }
        
        var isEnough = false
        
        networkAdapter.balance(address: address) { [weak self] result in
            if let balance = try? result(), let balanceNumber = BigUInt(balance.balance) {
                isEnough = balanceNumber >= amountNumber + feeNumber
            }
            self?.semaphore.signal()
        }
        
        semaphore.wait()
        
        return isEnough
    }
    
    private func getIsEnoughtTokenAmount(address: String, tokenAddress: String, amount: String) -> Bool {
        guard let amountNumber = BigUInt(amount) else {
            return false
        }
        
        var isEnough = false
        
        networkAdapter.tokenBalance(address: address, tokenAddress: tokenAddress) { [weak self] result in
            if let balance = try? result(), let balanceNumber = BigUInt(balance.balance) {
                isEnough = balanceNumber >= amountNumber
            }
            self?.semaphore.signal()
        }
        
        semaphore.wait()
        
        return isEnough
    }
    
    private func getETHNetworkInfo(
        fromAddress: String,
        toAddress: String,
        value: String,
        data: String = ""
        ) throws -> (estimateGas: BigUInt, gasPrice: BigUInt, nonce: BigUInt, fee: BigUInt) {
        var estimates: (BigUInt, BigUInt, BigUInt, BigUInt)?
        
        networkAdapter.estimateGas(from: fromAddress,
                                   to: toAddress,
                                   value: value,
                                   data: data) { [weak self] result in
            if let gas = try? result(),
                let gasPrice = BigUInt(gas.gasPrice),
                let gasLimit = BigUInt(gas.esimateGas) {
                let nonce = BigUInt(gas.nonce)
                let fee = gasLimit * gasPrice
                estimates = (gasLimit, gasPrice, nonce, fee)
            }
            self?.semaphore.signal()
        }
        
        semaphore.wait()
        
        guard let result = estimates else {
            throw ETHTransferError.networkParams
        }
        
        return result
    }
    
    private func getBytecode(address: String, value: String) throws -> (hex: String, data: Data) {
        guard let hex = bytecodeCoreComponent.sendTokenBytecode(address: address, value: value),
            let data = Data.fromHex(hex) else {
            throw ETHTransferError.invalidInputs
        }
        return (hex, data)
    }
    
    private func createTranscation(nonce: BigUInt,
                                   gasLimit: BigUInt,
                                   gasPrice: BigUInt,
                                   toAddress: web3swift.Address,
                                   value: BigUInt) throws -> EthereumTransaction {
        let gasPriceWithFee = gasPrice
        let transaction = EthereumTransaction(nonce: nonce,
                                              gasPrice: gasPriceWithFee,
                                              gasLimit: gasLimit,
                                              to: toAddress,
                                              value: value,
                                              data: Data(),
                                              v: 1, r: 0, s: 0)
        return transaction
    }
    
    private func createTokenTranscation(nonce: BigUInt,
                                        gasLimit: BigUInt,
                                        gasPrice: BigUInt,
                                        toAddress: web3swift.Address,
                                        data: Data,
                                        value: BigUInt) throws -> EthereumTransaction {
        let gasPriceWithFee = gasPrice
        
        let transaction = EthereumTransaction(nonce: nonce,
                                              gasPrice: gasPriceWithFee,
                                              gasLimit: gasLimit,
                                              to: toAddress,
                                              value: value,
                                              data: data,
                                              v: 1, r: 0, s: 0)
        return transaction
    }
    
    private func signTransaction(transaction: inout EthereumTransaction, keystore: BIP32Keystore) throws -> String {
        let addressString = self.ethCoreComponent.getAddress(keystore: keystore)
        let address = try self.getAddressFromString(addressString)
        try Web3Signer.signTX(transaction: &transaction, keystore: keystore, account: address, password: Constants.AuthConstants.keystorePass)
        guard let transactionHex = transaction.encode(forSignature: false, chainId: .default)?.hex else {
            throw ETHTransferError.signTx
        }
    
        return "0x" + transactionHex
    }
    
    private func sendTransaction(txString: String) throws {
        var isSuccess = false
        networkAdapter.sendRawTransaction(transaction: txString) { [weak self] result in
            do {
                _ = try result()
                isSuccess = true
            } catch {
                isSuccess = false
            }
            self?.semaphore.signal()
        }
        
        semaphore.wait()
        
        guard isSuccess == true else {
            throw ETHTransferError.sendFailure
        }
    }
}

extension ETHTransferServiceImp: ETHNetworkConfigurable {
    func configure(with networkAdapter: ETHNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
    func configure(with networkType: ETHNetworkType) {
        currentNetwork = networkType
    }
}
