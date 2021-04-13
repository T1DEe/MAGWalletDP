//
//  BTCNetworkAdapterImp.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoAPI

final class BTCNetworkAdapterImp: BTCNetworkAdapter {
    var api: CryptoAPI!
    
    func balance(address: String, completion: @escaping ((Result<BTCWalletBalanceModel, BTCWalletMappedError>) -> Void)) {
        api.btc.addressesUxtoInfo(addresses: [address]) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(models):
                guard let model = models.first else {
                    completion(.failure(.invalidData))
                    return
                }
                let balance = self.mapBalanceResponce(model: model)
                completion(.success(balance))
                
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(.operationError))
            }
        }
    }
    
    func sendRawTransaction(
        transactionHex: String,
        completion: @escaping ((Result<Void, BTCWalletMappedError>) -> Void)
    ) {
        api.btc.sendRaw(transaction: transactionHex) { result in
            switch result {
            case .success(let txResult):
                print(txResult.result)
                completion(.success(()))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.operationError))
            }
        }
    }
    
    func history(
        address: String,
        skip: Int?,
        limit: Int?,
        completion: @escaping ((Result<BTCPagedResponse<BTCWalletHistoryModel>, BTCWalletMappedError>) -> Void)
    ) {
        api.btc.addressesTransactionsHistory(addresses: [address], skip: skip ?? 0, limit: limit ?? 0) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(history):
                let history = self.mapHistoryResponse(model: history, skip: skip ?? 0)
                completion(.success(history))
                
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(.operationError))
            }
        }
    }
    
    func unspentOutputs(
        address: String,
        completion: @escaping ( (Result<[BTCWalletOutputModel], BTCWalletMappedError>) -> Void)
    ) {
        api.btc.addressesOutputs(addresses: [address], status: "unspent", skip: 0, limit: nil) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(models):
                let outputs = self.mapOutputsResponse(model: models)
                completion(.success(outputs))

            case let .failure(error):
                print(error)
                completion(.failure(.operationError))
            }
        }
    }
    
    func getFeePerKb(completion: @escaping ((Result<String, BTCWalletMappedError>) -> Void)) {
        api.btc.feePerKb { result in
            switch result {
            case .success(let fee):
                completion(.success(fee))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.operationError))
            }
        }
    }
    
    func rate(completion: @escaping (Result<BTCCoinRateModel, BTCWalletMappedError>) -> Void) {
        api.rates.rates(coins: [.BTC]) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let model):
                let rate = self.mapRateResponse(model: model)
                completion(.success(rate))
                
            case .failure:
                completion(.failure(.operationError))
            }
        }
    }
    
    func rateHistory(completion: @escaping (Result<[BTCCoinHistoryRateModel], BTCWalletMappedError>) -> Void) {
        api.rates.ratesHistory(coins: [.BTC]) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let models):
                let rates = self.mapRatesHistory(models: models)
                completion(.success(rates))
                
            case .failure:
                completion(.failure(.operationError))
            }
        }
    }
    
    func subscribeToPushNotifications(
        addresses: [String],
        firebaseToken: String,
        types: [BTCNotificationType],
        completion: @escaping (() throws -> (BTCNotificationModel)) -> Void
    ) {
        let types = mapNotificationTypes(types: types)
        api.btc.subscribePushNotifications(addresses: addresses, firebaseToken: firebaseToken, types: types) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let model):
                let notifications = self.mapNotifications(model: model)
                completion({ notifications })
                
            case .failure(let error):
                completion({ throw error })
            }
        }
    }
    
    func unsubscribePushNotifications(
        addresses: [String],
        firebaseToken: String,
        types: [BTCNotificationType],
        completion: @escaping (() throws -> (BTCNotificationModel)) -> Void
    ) {
        let notificationTypes = mapNotificationTypes(types: types)
        api.btc.unsubscribePushNotifications(
            addresses: addresses,
            firebaseToken: firebaseToken,
            types: notificationTypes
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let model):
                let notifications = self.mapNotifications(model: model)
                completion({ notifications })
                
            case .failure(let error):
                switch error {
                case .customErrorList(let typedError):
                    if typedError.status == 422 && typedError.errors.first?.field == "token" {
                        let notifications = BTCNotificationModel(addresses: addresses, token: firebaseToken, types: types)
                        completion({ notifications })
                    }
                    
                default:
                    completion({ throw error })
                }
            }
        }
    }
}

extension BTCNetworkAdapterImp {
    func mapHistoryResponse(model: BTCAddressOutHistoryResponseModel, skip: Int) -> BTCPagedResponse<BTCWalletHistoryModel> {
        var history = [BTCWalletHistoryModel]()
        
        model.items.forEach { item in
            var inputs = [BTCWalletTransactionInputModel]()
            var outputs = [BTCWalletTransactionOutputModel]()
            
            item.inputs.forEach { input in
                let input = BTCWalletTransactionInputModel(address: input.address ?? "",
                                                           prevTransactionHash: input.prevTransactionHash,
                                                           outputIndex: input.outputIndex,
                                                           sequenceNumber: input.sequenceNumber,
                                                           script: input.script)
                inputs.append(input)
            }
            
            item.outputs.forEach { output in
                let output = BTCWalletTransactionOutputModel(address: output.address ?? "",
                                                             satoshis: output.satoshis,
                                                             script: output.script)
                outputs.append(output)
            }
            
            let historyItem = BTCWalletHistoryModel(blockHeight: item.blockHeight,
                                                    blockHash: item.blockHash ?? "",
                                                    blockTime: item.blockTime ?? "",
                                                    mempoolTime: item.mempoolTime,
                                                    fee: item.fee,
                                                    size: item.size,
                                                    transactionIndex: item.transactionIndex,
                                                    lockTime: item.lockTime,
                                                    value: item.value,
                                                    hash: item.hash,
                                                    inputCount: item.inputCount,
                                                    outputCount: item.outputCount,
                                                    inputs: inputs,
                                                    outputs: outputs)
            
            history.append(historyItem)
        }
        
        return BTCPagedResponse<BTCWalletHistoryModel>(totalResults: model.count, data: history)
    }
    
    func mapOutputsResponse(model: [BTCAddressOutputResponseModel]) -> [BTCWalletOutputModel] {
        var outputs = [BTCWalletOutputModel]()
        
        model.forEach { item in
            let address = item.address
            let isCoibase = item.isCoinbase
            let mintBlockHeight = item.mintBlockHeight
            let script = item.script
            let value = item.value
            let mintIndex = item.mintIndex
            let mintTransactionHash = item.mintTransactionHash
            let spentBlockHeight = item.spentBlockHeight
            let spentTransactionHash = item.spentTransactionHash
            let spentIndex = item.spentIndex
            let sequenceNumber = item.sequenceNumber
            let mempoolTime = item.mempoolTime
            
            let outputItem = BTCWalletOutputModel(address: address,
                                                  isCoibase: isCoibase,
                                                  mintBlockHeight: mintBlockHeight,
                                                  script: script,
                                                  value: value,
                                                  mintIndex: mintIndex,
                                                  mintTransactionHash: mintTransactionHash,
                                                  spentBlockHeight: spentBlockHeight,
                                                  spentTransactionHash: spentTransactionHash ?? "",
                                                  spentIndex: spentIndex,
                                                  sequenceNumber: sequenceNumber,
                                                  mempoolTime: mempoolTime ?? "")
            outputs.append(outputItem)
        }
        
        return outputs
    }
    
    func mapBalanceResponce(model: BTCAddressOutInfoResponseModel) -> BTCWalletBalanceModel {
        let balance = model.balance.unspent
        
        return BTCWalletBalanceModel(balance: balance)
    }
    
    func mapRateResponse(model: [RatesResponseModel]) -> BTCCoinRateModel {
        guard let btcRateUsd = model.first?.rate.usd else {
            return BTCCoinRateModel(rate: "0")
        }
        let btcRate = BTCCoinRateModel(rate: btcRateUsd)
        return btcRate
    }
    
    private func mapRatesHistory(models: [RatesHistoryResponseModel]) -> [BTCCoinHistoryRateModel] {
        guard let rateHistory = models.first else {
            return []
        }
        var rates: [BTCCoinHistoryRateModel] = []
        rateHistory.rates.forEach { item in
            rates.append(BTCCoinHistoryRateModel(date: item.createdAt, rates: [item.rate.usd]))
        }
        return rates
    }
    
    private func mapNotifications(model: BTCPushNotificationsResponseModel) -> BTCNotificationModel {
        let types = model.types.compactMap { BTCNotificationType(rawValue: $0.rawValue) }
        return BTCNotificationModel(addresses: model.addresses, token: model.token, types: types)
    }
    
    private func mapNotificationTypes(types: [BTCNotificationType]) -> [CryptoNotificationType] {
        return types.compactMap { CryptoNotificationType(rawValue: $0.rawValue) }
    }
}
