//
//  HistoryInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum HistoryDirection {
    case top
    case bottom
}

class HistoryInteractor {
    weak var output: HistoryInteractorOutput!
    var ethUpdateFacade: ETHUpdateService!
    var ethAuthFacade: ETHAuthService!
    var settingsConfiguration: ETHSettingsConfiguration!
    var ethUpdateActionHandler: ETHUpdateEventActionHandler!
    var authEventDelegateHandler: AuthEventDelegateHandler!
    var snackBarsActionHandler: SnackBarsActionHandler!
    
    var historyStore = HistoryPaginationStore<EthHistoryModel, ETHWalletHistoryEntity>(
        from: 0, limit: 10, ratesLoaded: false
    )
    var tokenHistoryStore = HistoryPaginationStore<EthHistoryModel, ETHWalletTokenHistoryEntity>(
        from: 0, limit: 10, ratesLoaded: false
    )
    
    let semaphore = DispatchSemaphore(value: 0)
    let workingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let emptyBalanceString = "0"
    let usdCurrency = Currencies.usd
}

// MARK: - HistoryInteractorInput

extension HistoryInteractor: HistoryInteractorInput {
    func bindToEvents() {
        authEventDelegateHandler.delegate = self
    }
    
    func loadHistoryFromStart(for currency: Currency) {
        workingQueue.cancelAllOperations()
        if currency.isToken {
            tokenHistoryStore.clear()
            queryTokenHistory(from: tokenHistoryStore.from)
        } else {
            historyStore.clear()
            queryHistory(from: historyStore.from)
        }
        //we dont have socket but we need to update our balances
        ethUpdateActionHandler.actionUpdateBalance()
    }
    
    func loadNextHistoryPage(for currency: Currency) {
        if currency.isToken {
            queryTokenHistory(from: tokenHistoryStore.from)
        } else {
            queryHistory(from: historyStore.from)
        }
    }
    
    func hasEthAccount() -> Bool {
        return ethAuthFacade.hasWallets
    }
    
    func hasAdditionalToken() -> Bool {
        return settingsConfiguration.hasAdditionalToken
    }
    
    func getAllCurrencies() -> [Currency] {
        var currencies: [Currency] = []
        if hasEthAccount() {
            currencies.append(ETHCurrency.ethCurrency)
        }
        if let token = settingsConfiguration.additionalToken {
            currencies.append(token)
        }
        return currencies
    }
    
    func presentSnackbar(snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func getHistoryOriginalTransaction(transaction: EthHistoryModel) -> ETHWalletHistoryEntity? {
        return historyStore.originalTransactions[transaction.id]
    }
    
    func getTokenHistoryOriginalTransaction(transaction: EthHistoryModel) -> TokenHistoryEntity? {
        if let originalTransaction = tokenHistoryStore.originalTransactions[transaction.id],
            let currentWallet = try? self.ethAuthFacade.getCurrentWallet(),
            let token = settingsConfiguration.additionalToken {
            return TokenHistoryEntity(
                original: originalTransaction,
                tokenCurrency: token,
                isReceive: compareAddresses(first: originalTransaction.toAddress, second: currentWallet.address)
            )
        }
        return .none
    }
    
    private func queryHistory(from: Int) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self]  in
            guard let self = self else {
                return
            }
            guard let currentWallet = try? self.ethAuthFacade.getCurrentWallet() else {
                return
            }
            let currency = ETHCurrency.ethCurrency
            
            self.ethUpdateFacade.obtainWalletHistory(
                wallet: currentWallet, currency: currency, from: from, limit: self.historyStore.limit
            ) { [weak self, weak operation] result in
                guard let strongSelf = self, operation?.isCancelled == false else {
                    self?.semaphore.signal()
                    return
                }
                do {
                    let data = try result.get()
                    
                    if strongSelf.historyStore.ratesLoaded {
                        let rate = strongSelf.ethUpdateFacade.getLocalRate(for: currency)
                        let pageResponse = strongSelf.processHistoryResponse(data: data, rate: .value(rate))
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.output?.historyLoaded(responce: pageResponse)
                        }
                        
                        strongSelf.semaphore.signal()
                    } else {
                        strongSelf.ethUpdateFacade.obtainRate(for: currency) { [weak self, weak operation] result in
                            guard let strongSelf = self, operation?.isCancelled == false else {
                                self?.semaphore.signal()
                                return
                            }
                            var rate: EthHistoryRateValue = .none
                            switch result {
                            case .success(let model):
                                strongSelf.historyStore.ratesLoaded = true
                                rate = .value(model.rate)
                                
                            case .failure:
                                rate = .none
                            }
                            
                            let pageResponse = strongSelf.processHistoryResponse(data: data, rate: rate)
                            DispatchQueue.main.async { [weak self] in
                               self?.output?.historyLoaded(responce: pageResponse)
                            }
                            
                            strongSelf.semaphore.signal()
                        }
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.output?.historyLoadFailed()
                    }
                    
                    strongSelf.semaphore.signal()
                }
            }
            self.semaphore.wait()
        }
        workingQueue.addOperation(operation)
    }
    
    private func queryTokenHistory(from: Int) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self]  in
            guard let self = self else {
                return
            }
            guard let currentWallet = try? self.ethAuthFacade.getCurrentWallet() else {
                return
            }
            guard let token = self.settingsConfiguration.additionalToken else {
                return
            }
            
            self.ethUpdateFacade.obtainTokenHistory(
                wallet: currentWallet, currency: token, from: from, limit: self.tokenHistoryStore.limit
            ) { [weak self, weak currentWallet, weak operation] result in
                guard let strongSelf = self, let wallet = currentWallet, operation?.isCancelled == false else {
                    self?.semaphore.signal()
                    return
                }
                switch result {
                case .success(let model):
                    if strongSelf.tokenHistoryStore.ratesLoaded {
                        let rate = strongSelf.ethUpdateFacade.getLocalRate(for: token)
                        let pageResponse = strongSelf.processTokenHistoryResponse(
                            data: model,
                            walletAddress: wallet.address,
                            token: token,
                            rate: .value(rate)
                        )
                        DispatchQueue.main.async { [weak self] in
                            self?.output?.historyLoaded(responce: pageResponse)
                        }
                        strongSelf.semaphore.signal()
                    } else {
                        strongSelf.ethUpdateFacade.obtainRate(for: token) { [weak self, weak operation] result in
                            guard let strongSelf = self, operation?.isCancelled == false else {
                                self?.semaphore.signal()
                                return
                            }
                            var rate: EthHistoryRateValue = .none
                            switch result {
                            case .success(let model):
                                strongSelf.tokenHistoryStore.ratesLoaded = true
                                rate = .value(model.rate)
                                
                            case .failure:
                                rate = .none
                            }
                            
                            let pageResponse = strongSelf.processTokenHistoryResponse(
                                data: model,
                                walletAddress: wallet.address,
                                token: token,
                                rate: rate
                            )
                            DispatchQueue.main.async { [weak self] in
                               self?.output?.historyLoaded(responce: pageResponse)
                            }
                            
                            strongSelf.semaphore.signal()
                        }
                    }
                    
                case .failure:
                    DispatchQueue.main.async { [weak self] in
                        self?.output?.historyLoadFailed()
                    }
                    
                    strongSelf.semaphore.signal()
                }
            }
            self.semaphore.wait()
        }
        workingQueue.addOperation(operation)
    }
    
    private func processHistoryResponse(
        data: ETHPagedResponse<ETHWalletHistoryEntity>,
        rate: EthHistoryRateValue
    ) -> PagedResponse<EthHistoryModel> {
        historyStore.appendTransactions(transactions: data.data, uniqueIds: data.data.map { $0.hash })
        let models = mapEthTransactions(data: data.data, rate: rate)
        let sortedTransaction = models.sorted {
            getDateValue(date: $0.date) > getDateValue(date: $1.date)
        }
        historyStore.currentTransactions.append(contentsOf: sortedTransaction)
        let uniqueTransactions = removeDublicates(from: historyStore.currentTransactions)
        historyStore.from = uniqueTransactions.count
        let isFull = data.totalResults <= historyStore.from
        
        return PagedResponse(isFull: isFull, data: uniqueTransactions)
    }
    
    private func processTokenHistoryResponse(
        data: ETHPagedResponse<ETHWalletTokenHistoryEntity>,
        walletAddress: String,
        token: Currency,
        rate: EthHistoryRateValue
    ) -> PagedResponse<EthHistoryModel> {
        tokenHistoryStore.appendTransactions(
            transactions: data.data,
            uniqueIds: data.data.map { $0.transactionHash }
        )
        let models = mapEthTokenTransactions(data: data.data, walletAddress: walletAddress, token: token, rate: rate)
        let sortedTransaction = models.sorted {
            getDateValue(date: $0.date) > getDateValue(date: $1.date)
        }
        tokenHistoryStore.currentTransactions.append(contentsOf: sortedTransaction)
        let uniqueTransactions = removeDublicates(from: tokenHistoryStore.currentTransactions)
        tokenHistoryStore.from = uniqueTransactions.count
        let isFull = data.totalResults <= tokenHistoryStore.from
        
        return PagedResponse(isFull: isFull, data: uniqueTransactions)
    }
    
    private func mapEthTransactions(data: [ETHWalletHistoryEntity], rate: EthHistoryRateValue) -> [EthHistoryModel] {
        let eth = Constants.ETHConstants.ETHSymbol
        var models = [EthHistoryModel]()
        
        for transaction in data {
            var value = transaction.value
            var toAddress = transaction.toAddress
            var fromAddress = transaction.fromAddress
            if let internalTransaction = transaction.internalTransaction {
                value = internalTransaction.value
                toAddress = internalTransaction.to
                fromAddress = internalTransaction.from
            }
            let amount = divideAmountByDecimals(amount: value)
            let formattedAmount = transaction.isReceive ?
                mapAttributedStringForReceive(symbol: eth, amount: amount.toFormattedCropNumber()) :
                mapAttributedStringForSend(symbol: eth, amount: amount.toFormattedCropNumber())
            
            var rateValue = String()
            
            if case let .value(rate) = rate {
                rateValue = usdCurrency.symbol +
                    BigDecimalNumber(amount).toFormattedCropNumber(multiplier: rate, precision: usdCurrency.decimals)
            }
            
            let model = EthHistoryModel(id: transaction.hash,
                                        date: toFormattedDate(date: transaction.creationFullDate),
                                        amount: amount,
                                        amountFormatted: formattedAmount,
                                        isReceiving: transaction.isReceive,
                                        fromAddress: fromAddress,
                                        toAddress: toAddress,
                                        fee: countFee(transaction: transaction) + " " + eth,
                                        rate: rateValue)
            
            models.append(model)
        }
        
        return models
    }
    
    func mapEthTokenTransactions(
        data: [ETHWalletTokenHistoryEntity],
        walletAddress: String,
        token: Currency,
        rate: EthHistoryRateValue
    ) -> [EthHistoryModel] {
        var models = [EthHistoryModel]()
        
        for transaction in data {
            let id = transaction.transactionHash
            let value = transaction.value
            let toAddress = transaction.toAddress
            let fromAddress = transaction.fromAddress
            let isReceive = compareAddresses(first: toAddress, second: walletAddress)
            
            let amount = BigDecimalNumber(hex: value).powerOfMinusTen(BigDecimalNumber(token.decimals))
            let formattedAmount = isReceive ?
                mapAttributedStringForReceive(symbol: token.symbol, amount: amount.toFormattedCropNumber()) :
                mapAttributedStringForSend(symbol: token.symbol, amount: amount.toFormattedCropNumber())
            
            var rateValue = String()
            
            if case let .value(rate) = rate {
                rateValue = usdCurrency.symbol +
                    BigDecimalNumber(amount).toFormattedCropNumber(multiplier: rate, precision: usdCurrency.decimals)
            }
            
            let model = EthHistoryModel(
                id: id,
                date: toFormattedDate(date: transaction.timestamp),
                amount: amount,
                amountFormatted: formattedAmount,
                isReceiving: isReceive,
                fromAddress: fromAddress,
                toAddress: toAddress,
                fee: emptyBalanceString,
                rate: rateValue
            )
            
            models.append(model)
        }
        
        return models
    }
    
    private func removeDublicates(from models: [EthHistoryModel]) -> [EthHistoryModel] {
        var ids = Set<String>()
        var entities = [EthHistoryModel]()
        
        for item in models {
            if ids.contains(item.id) {
                continue
            }
            
            ids.insert(item.id)
            entities.append(item)
        }
        
        return entities
    }

    private func mapAttributedStringForReceive(symbol: String, amount: String) -> NSAttributedString {
        let amount = NSMutableAttributedString(
            string: amount + " ",
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 17) ?? UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: R.color.dark() ?? .black
            ]
        )
        
        let symbolAttributed = NSMutableAttributedString(
            string: symbol,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 12) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .gray
            ]
        )
        
        amount.append(symbolAttributed)
        
        return amount
    }

    private func mapAttributedStringForSend(symbol: String, amount: String) -> NSAttributedString {
        let amount = NSMutableAttributedString(
            string: "- " + amount + " ",
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 17) ?? UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: R.color.pink() ?? .red
            ]
        )
        
        let symbolAttributed = NSMutableAttributedString(
            string: symbol,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 12) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .gray
            ]
        )
        
        amount.append(symbolAttributed)
        
        return amount
    }
    
    private func countFee(transaction: ETHWalletHistoryEntity) -> String {
        let gasPrice = BigDecimalNumber(transaction.gasPrice)
        let gasUsed = BigDecimalNumber(transaction.gasUsed)
        let fee = divideAmountByDecimals(amount: (gasPrice * gasUsed).stringValue)
        return fee
    }
    
    private func divideAmountByDecimals(amount: String) -> String {
        return BigDecimalNumber(amount).powerOfMinusTen(BigDecimalNumber(Constants.ETHConstants.ETHDecimal))
    }
    
    private func toFormattedDate(date: String) -> String {
        let date = getDateValue(date: date)
        let dateString = mapDate(date: date)
        return dateString
    }
    
    private func mapDate(date: Date) -> String {
        let localDateAsString = DateFormatter.mapHistoryDate(date: date)
        return localDateAsString
    }
    
    private func getDateValue(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: date) ?? Date()
    }
    
    private func compareAddresses(first: String, second: String) -> Bool {
        return first.lowercased() == second.lowercased()
    }
}

// MARK: AuthEventDelegate

extension HistoryInteractor: AuthEventDelegate {
    func didNewWalletSelected() {
        output.didNewWalletSelected()
    }
    
    func didAuthCompleted() {
    }
}
