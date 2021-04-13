//
//  ETHNetworkAdapter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CryptoAPI

final class ETHNetworkAdapterImp: ETHNetworkAdapter {
    var api: CryptoAPI!

    func history(address: String, from: Int?, limit: Int?, completion: @escaping (() throws -> (ETHPagedResponse<ETHWalletHistoryEntity>)) -> Void) {
        api.eth.transfers(skip: from ?? 0, limit: limit ?? 0, addresses: [address], positive: true, pending: .exclude) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(history):
                do {
                    let hisory = try self.mapHistoryResponse(model: history, from: from ?? 0, address: address)
                    completion({ hisory })
                } catch let error {
                    completion({ throw error })
                }
                
            case let .failure(error):
                completion({ throw error })
            }
        }
    }
    
    func tokenHistory(tokenAddress: String,
                      address: String,
                      from: Int?,
                      limit: Int?,
                      completion: @escaping (() throws -> (ETHPagedResponse<ETHWalletTokenHistoryEntity>)) -> Void) {
        api.eth.tokenTransfers(tokenAddress: tokenAddress, addresses: [address], skip: from ?? 0, limit: limit ?? 0) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(model):
                
                do {
                    let hisory = try self.mapTokenHistoryResponse(model: model, from: from ?? 0, address: address)
                    completion({ hisory })
                } catch let error {
                    completion({ throw error })
                }

            case let .failure(error):
                completion({ throw error })
            }
        }
    }
    
    func balance(address: String, completion: @escaping (() throws -> (ETHWalletBalanceModel)) -> Void) {
        api.eth.balance(addresses: [address]) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(models):
                
                do {
                    let balance = try self.mapBalanceResponce(models: models, address: address)
                    completion({ balance })
                } catch let error {
                    completion({ throw error })
                }

            case let .failure(error):
                completion({ throw error })
            }
        }
    }
    
    func tokenBalance(address: String,
                      tokenAddress: String,
                      completion: @escaping (() throws -> (ETHWalletBalanceModel)) -> Void) {
        api.eth.tokensBalance(addresses: [address], skip: 0, limit: 30, token: tokenAddress) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(model):
                
                do {
                    let balance = try self.mapTokenBalanceResponce(model: model, tokenAddress: tokenAddress)
                    completion({ balance })
                } catch let error {
                    completion({ throw error })
                }

            case let .failure(error):
                completion({ throw error })
            }
        }
    }
    
    func sendRawTransaction(transaction: String, completion: @escaping (() throws -> Void) -> Void) {
        api.eth.sendRaw(transaction: transaction) { result in
            switch result {
            case .success:
                completion({ })
                
            case let .failure(error):
                completion({ throw error })
            }
        }
    }
    
    func estimateGas(from: String, to: String, value: String, data: String, completion: @escaping (() throws -> (EtherEstimatesModel)) -> Void) {
        api.eth.estimateGas(fromAddress: from, toAddress: to, data: data, value: value) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case let .success(model):
                do {
                    let estimates = try self.mapEstimatesResponse(model: model)
                    
                    completion({ estimates })
                } catch let error {
                    completion({ throw error })
                }

            case let .failure(error):
                completion({ throw error })
            }
        }
    }
    
    func rate(coin: CryptoCurrencyType, completion: @escaping (() throws -> (ETHCoinRateModel)) -> Void) {
        api.rates.rates(coins: [coin]) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let model):
                let rate = self.mapRates(model: model)
                completion({ rate })
                
            case .failure(let error):
                completion({ throw error })
            }
        }
    }
    
    func rateHistory(coin: CryptoCurrencyType, completion: @escaping (() throws -> ([ETHCoinHistoryRateModel])) -> Void) {
        api.rates.ratesHistory(coins: [coin]) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let models):
                do {
                    let rates = try self.mapRatesHistory(models: models)
                    completion({ rates })
                } catch let error {
                    completion({ throw error })
                }
                
            case .failure(let error):
                completion({ throw error })
            }
        }
    }
    
    func subscribeToPushNotifications(
        addresses: [String],
        firebaseToken: String,
        types: [ETHNotificationType],
        completion: @escaping (() throws -> (ETHNotificationModel)) -> Void
    ) {
        let types = mapNotificationTypes(types: types)
        api.eth.subscribePushNotifications(addresses: addresses, firebaseToken: firebaseToken, types: types) { [weak self] result in
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
        types: [ETHNotificationType],
        completion: @escaping (() throws -> (ETHNotificationModel)) -> Void
    ) {
        let notificationTypes = mapNotificationTypes(types: types)
        api.eth.unsubscribePushNotifications(
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
                        let notifications = ETHNotificationModel(addresses: addresses, token: firebaseToken, types: types)
                        completion({ notifications })
                    }
                    
                default:
                    completion({ throw error })
                }
            }
        }
    }
}

extension ETHNetworkAdapterImp {
    func mapHistoryResponse(model: ETHTransfersResponseModel, from: Int, address: String) throws -> ETHPagedResponse<ETHWalletHistoryEntity> {
        var history = [ETHWalletHistoryEntity]()
        
        model.items.forEach { item in
            let from = item.from
            let to = item.to
            let isConfirmed = true // coz we always have block number
            let value = item.value
            let creationDate = item.utc
            let gasUsed = String(item.gas)
            let gasPrice = item.gasPrice
            let isReceive = !(from.lowercased() == address.lowercased())
            let hash = item.hash
            let nonce = 0
            let isInternal = item.isInternal
            let blockNumber = item.blockNumber
            let hisoryItem = ETHWalletHistoryEntity(hash: hash,
                                                    isConfirmed: isConfirmed,
                                                    isReceive: isReceive,
                                                    creationFullDate: creationDate,
                                                    fromAddress: from,
                                                    toAddress: to,
                                                    value: value,
                                                    gasUsed: gasUsed,
                                                    gasPrice: gasPrice,
                                                    nonce: nonce,
                                                    blockNumber: blockNumber ?? 0,
                                                    internal: isInternal,
                                                    internalTransaction: nil)
            history.append(hisoryItem)
        }

        history = history.sorted {
            $0.creationFullDate > $1.creationFullDate
        }

        return  ETHPagedResponse<ETHWalletHistoryEntity>(totalResults: model.count, data: history)
    }
    
    func mapTokenHistoryResponse(model: ETHTokenTransfersResponseModel,
                                 from: Int, address: String) throws -> ETHPagedResponse<ETHWalletTokenHistoryEntity> {
        var history = [ETHWalletTokenHistoryEntity]()
        
        model.items.forEach { item in
            let from = item.from
            let to = item.to
            let blockNumber = item.blockNumber
            let value = item.value
            let creationDate = item.utc
            let hash = item.transactionHash
            let index = item.transactionIndex
            let address = item.address
            let executeAddress = item.executeAddress
            let type = item.type
            
            let hisoryItem = ETHWalletTokenHistoryEntity(type: type,
                                                         executeAddress: executeAddress,
                                                         fromAddress: from,
                                                         toAddress: to,
                                                         value: value,
                                                         address: address,
                                                         blockNumber: blockNumber,
                                                         transactionHash: hash,
                                                         transactionIndex: index,
                                                         timestamp: creationDate)
            history.append(hisoryItem)
        }
        
        return ETHPagedResponse<ETHWalletTokenHistoryEntity>(totalResults: model.count, data: history)
    }
    
    func mapEstimatesResponse(model: ETHEstimateGasResponseModel) throws -> EtherEstimatesModel {
        let estimateGas = String(model.estimateGas)
        let gasPrice = model.gasPrice
        let nonce = model.nonce
        
        return EtherEstimatesModel(esimateGas: estimateGas,
                                   gasPrice: gasPrice,
                                   nonce: nonce)
    }
    
    func mapTokenBalanceResponce(model: ETHTokensBalanceResponseModel, tokenAddress: String) throws -> ETHWalletBalanceModel {
        var addressBalance: String?
        model.items.forEach {
            if $0.address.lowercased() == tokenAddress.lowercased() {
                addressBalance = $0.balance
            }
        }
        
        guard let balance = addressBalance else {
            return ETHWalletBalanceModel(balance: "0")
        }
        
        return ETHWalletBalanceModel(balance: balance)
    }
    
    func mapBalanceResponce(models: [ETHBalanceResponseModel], address: String) throws -> ETHWalletBalanceModel {
        var addressBalance: String?
        models.forEach {
            if $0.address.lowercased() == address.lowercased() {
                addressBalance = $0.balance
            }
        }
        
        guard let balance = addressBalance else {
            return ETHWalletBalanceModel(balance: "0")
        }
        
        return ETHWalletBalanceModel(balance: balance)
    }
    
    private func mapRates(model: [RatesResponseModel]) -> ETHCoinRateModel {
        guard let ethRateUsd = model.first?.rate.usd else {
            return ETHCoinRateModel(rate: "0")
        }
        let ethRate = ETHCoinRateModel(rate: ethRateUsd)
        return ethRate
    }
    
    private func mapRatesHistory(models: [RatesHistoryResponseModel]) throws -> [ETHCoinHistoryRateModel] {
        guard let rateHistory = models.first else {
            throw ETHWalletMapError.invalidFormat
        }
        var rates: [ETHCoinHistoryRateModel] = []
        rateHistory.rates.forEach { item in
            rates.append(ETHCoinHistoryRateModel(date: item.createdAt, rates: [item.rate.usd]))
        }
        return rates
    }
    
    private func mapNotifications(model: ETHPushNotificationsResponseModel) -> ETHNotificationModel {
        let types = model.types.compactMap { ETHNotificationType(rawValue: $0.rawValue) }
        return ETHNotificationModel(addresses: model.addresses, token: model.token, types: types)
    }
    
    private func mapNotificationTypes(types: [ETHNotificationType]) -> [CryptoNotificationType] {
        return types.compactMap { CryptoNotificationType(rawValue: $0.rawValue) }
    }
}
