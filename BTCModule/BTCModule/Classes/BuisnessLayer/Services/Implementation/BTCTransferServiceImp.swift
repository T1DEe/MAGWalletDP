//
//  BTCTransferServiceImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BigNumber
import SharedFilesModule

final class BTCTransferServiceImp: BTCTransferService {
    var btcCoreComponent: BTCCoreComponent!
    var networkAdapter: BTCNetworkAdapter!
    var currentNetwork: BTCNetworkType!
    
    private let semaphore = DispatchSemaphore(value: 0)
    
    private let workingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func isValidAddress(_ address: String) -> Bool {
        guard let _ = try? self.getAddressFromString(address) else {
            return false
        }
        
        return true
    }
    
    func send(seed: String, toAddress: String, amount: String, completion: @escaping (Result<Void, BTCTransferError>) -> Void) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                let seedArray = seed.components(separatedBy: " ")
                let fromAddressString = try self.btcCoreComponent.getAddress(seed: seedArray, networkType: self.currentNetwork)
                
                guard self.isValidAddress(toAddress), let amountNumber = Int(amount) else {
                        completion(.failure(.invalidInputs))
                        return
                }
                
                let unspentOutputs = try self.getOutputs(address: fromAddressString)
                let feePerKb = try self.getFeePerKb()
                
                let estimatedFee = try self.getFee(
                    fromAddress: fromAddressString,
                    amount: amountNumber,
                    unspentOutputs: unspentOutputs,
                    feePerKb: feePerKb
                )
                
                let isEnoughMoney = try self.isEnoughAmount(address: fromAddressString, amount: amount, fee: estimatedFee.description)
                if isEnoughMoney == false {
                    completion(.failure(.notEnoughMoney))
                    return
                }
                
                let privateKey = try self.btcCoreComponent.generateKey(seed: seedArray, networkType: self.currentNetwork)
                
                guard let changeAddress = BTCAddress(string: fromAddressString),
                    let toAddress = BTCAddress(string: toAddress) else {
                        completion(.failure(.invalidInputs))
                        return
                }
                let amount = BTCAmount(amountNumber)
                let fee = BTCAmount(estimatedFee)
                
                let neededOutsModel = try self.selectNeededOutputs(for: amount + fee, from: unspentOutputs)
                
                guard let transaction = try self.btcCoreComponent.createTransaction(
                    privateKey: privateKey,
                    outputs: neededOutsModel.outs,
                    changeAddress: changeAddress,
                    toAddress: toAddress,
                    value: amount,
                    fee: fee,
                    checkSignature: true
                    ) else {
                    completion(.failure(.createTX))
                    return
                }
                
                guard let txHex = self.btcCoreComponent.getTransactionHex(transaction: transaction) else {
                        completion(.failure(.invalidInputs))
                        return
                }
                try self.sendTransaction(txHex: txHex)
                
                completion(.success(()))
            } catch let error as BTCTransferError {
                print(error)
                completion(.failure(error))
            } catch {
                completion(.failure(.sendFailure))
            }
        }
        workingQueue.addOperation(operation)
    }

    func estimate(fromAddress: String, amount: String, completion: @escaping ((Result<Int, BTCTransferError>) -> Void) ) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                guard let amount = Int(amount) else {
                    completion(.failure(.invalidInputs))
                    return
                }
                
                let unspentOutputs = try self.getOutputs(address: fromAddress)
                let feePerKb = try self.getFeePerKb()
                
                let fee = try self.getFee(
                    fromAddress: fromAddress,
                    amount: amount,
                    unspentOutputs: unspentOutputs,
                    feePerKb: feePerKb
                )
                
                completion(.success(fee))
            } catch let error as BTCTransferError {
                print(error)
                completion(.failure(error))
            } catch {
                completion(.failure(.feeEstimating))
            }
        }
        workingQueue.addOperation(operation)
    }
    
    // MARK: Private
    
    private func getFee(
        fromAddress: String,
        amount: Int,
        unspentOutputs: [BTCTransactionOutput],
        feePerKb: Int
    ) throws -> Int {
        var totalAmount = Int64(amount)
        var outsTotal = BTCAmount.zero
        var resultFee = 0
        
        repeat {
            let neededOutsModel = try self.selectNeededOutputs(for: totalAmount, from: unspentOutputs)
            outsTotal = neededOutsModel.selectedOutsAmount
            
            let fee = try self.calculateTxFee(amount: amount,
                                              feePerKb: feePerKb,
                                              outputs: neededOutsModel.outs
            )
            resultFee = fee
            
            totalAmount = BTCAmount(totalAmount) + BTCAmount(fee)
        } while outsTotal < totalAmount
        
        return resultFee
    }
    
    private func calculateTxFee(
        amount: Int,
        feePerKb: Int,
        outputs: [BTCTransactionOutput]
    ) throws -> Int {
        let fee = try btcCoreComponent.calculateTransactionFee(
            amount: amount,
            feePerKb: feePerKb,
            unspentOutputs: outputs,
            networkType: currentNetwork
        )
        
        return fee
    }
    
    private func getOutputs(address: String) throws -> [BTCTransactionOutput] {
        var unspentOutputs: [BTCWalletOutputModel]?
        
        networkAdapter.unspentOutputs(address: address) { [weak self] result in
            switch result {
            case .success(let outputs):
                unspentOutputs = outputs
                
            case .failure(let error):
                print(error)
            }
            
            self?.semaphore.signal()
        }
        
        semaphore.wait()
        
        guard let outs = unspentOutputs else {
            throw BTCTransferError.getUnspentOutputs
        }
        
        let mappedOuts = mapOutputsResponse(model: outs)
        return mappedOuts
    }
    
    private func selectNeededOutputs(
        for value: Int64,
        from: [BTCTransactionOutput]
    ) throws -> (outs: [BTCTransactionOutput], selectedOutsAmount: BTCAmount) {
        var neededOuts = [BTCTransactionOutput]()
        var total: BTCAmount = 0
        var utxos = from
        
        guard !utxos.isEmpty else {
            throw BTCCoreError.transactionGenerating
        }
        
        utxos = utxos.sorted { $0.value < $1.value }
        for txout in utxos {
            if txout.script.isPayToPublicKeyHashScript {
                neededOuts.append(txout)
                total += txout.value
            }
            
            if total >= value {
                break
            }
        }
        
        if total < value {
            throw BTCTransferError.notEnoughMoney
        }
        
        return (neededOuts, total)
    }
    
    private func getAddressFromString(_ addressString: String) throws -> BTCAddress {
        guard let address = BTCAddress(string: addressString) else {
            throw BTCTransferError.invalidInputs
        }
        return address
    }
    
    private func isEnoughAmount(address: String, amount: String, fee: String) throws -> Bool {
        guard let amountNumber = BTCAmount(amount), let feeNumber = BTCAmount(fee) else {
            return false
        }
        var isEnough = false
        
        networkAdapter.balance(address: address) { [weak self] result in
            switch result {
            case .success(let balance):
                if let balanceNumber = BTCAmount(balance.balance) {
                    isEnough = balanceNumber >= amountNumber + feeNumber
                }
                
            case .failure(let error):
                print(error)
            }
            self?.semaphore.signal()
        }
        semaphore.wait()
        
        return isEnough
    }
    
    private func getFeePerKb() throws -> Int {
        var feePerKbResponse: String?
        networkAdapter.getFeePerKb { [weak self] result in
            switch result {
            case .success(let fee):
                feePerKbResponse = fee
                
            case .failure(let error):
                print(error)
            }
            self?.semaphore.signal()
        }
        semaphore.wait()
        
        guard let feeString = feePerKbResponse else {
            throw BTCTransferError.networkParams
        }
        
        let value = BigDecimalNumber(feeString)
        let decimal = BigDecimalNumber(Constants.BTCConstants.BTCDecimalString)
        
        guard let result = Int(value.powerOfTen(decimal)) else {
            throw BTCTransferError.networkParams
        }
        
        return result
    }
    
    private func sendTransaction(txHex: String) throws {
        var isSuccess = false
        networkAdapter.sendRawTransaction(transactionHex: txHex) { [weak self] result in
            switch result {
            case .success:
                isSuccess = true
                
            case .failure(let error):
                print(error)
                isSuccess = false
            }
            self?.semaphore.signal()
        }
        
        semaphore.wait()
        
        guard isSuccess == true else {
            throw BTCTransferError.sendFailure
        }
    }
}

// maybe trables here
extension BTCTransferServiceImp {
    func mapOutputsResponse(model: [BTCWalletOutputModel]) -> [BTCTransactionOutput] {
        var outputs = [BTCTransactionOutput]()
        
        for item in model {
            let out = BTCTransactionOutput()
            out.value = BTCAmount(item.value)
            out.script = BTCScript(data: BTCDataFromHex(item.script))
            out.transactionHash = BTCDataFromHex(item.mintTransactionHash.invertHex())
            out.index = UInt32(item.mintIndex)
            out.blockHeight = item.mintBlockHeight
            
            outputs.append(out)
        }
        
        return outputs
    }
}

extension BTCTransferServiceImp: BTCNetworkConfigurable {
    func configure(with networkType: BTCNetworkType) {
        currentNetwork = networkType
    }
    
    func configure(with networkAdapter: BTCNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }
}

private extension String {
    func invertHex() -> String {
        let hexString = String(self)
        var reversedString = String()
        var charIndex = self.count
        
        while charIndex > 0 {
            charIndex -= 2
            let substring = hexString[charIndex..<charIndex + 2]
            let first: Character! = substring.first
            let last: Character! = substring.last
            reversedString += String(describing: String(first))
            reversedString += String(describing: String(last))
        }
        
        return reversedString
    }
}
