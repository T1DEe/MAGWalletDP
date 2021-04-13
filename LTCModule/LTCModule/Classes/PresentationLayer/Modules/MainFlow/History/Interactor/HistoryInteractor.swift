//
//  HistoryHistoryInteractor.swift
//  LTCModule
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
    var authEventDelegateHandler: AuthEventDelegateHandler!
    var ltcUpdateFacade: LTCUpdateService!
    var ltcAuthFacade: LTCAuthService!
    var ltcUpdateActionHandler: LTCUpdateEventActionHandler!
    
    var currentTransactions = [LTCHistoryEntity]()
    var originalTransactions = [String: LTCWalletHistoryModel]()

    var skip = 0
    var limit = 10
    var ratesLoaded = false
    
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
    func hasLTCAccount() -> Bool {
        return ltcAuthFacade.hasWallets
    }
    
    func loadNextHistoryPage() {
        queryHistory(skip: skip)
    }
    
    func getOriginalTransaction(transaction: LTCHistoryEntity) -> LTCWalletHistoryModel? {
        let originalTransaction = originalTransactions[transaction.id]
        return originalTransaction
    }
    
    func bindToEvents() {
        authEventDelegateHandler.delegate = self
    }
    
    func loadHistoryFromStart() {
        ratesLoaded = false
        skip = 0
        currentTransactions.removeAll()
        originalTransactions.removeAll()
        workingQueue.cancelAllOperations()
        queryHistory(skip: skip)
        //we dont have socket but we need to update our balances
        ltcUpdateActionHandler.actionUpdateBalance()
    }
    
    // MARK: Private
    
    private func queryHistory(skip: Int) {
        let operation = BlockOperation()
        
        operation.addExecutionBlock { [weak self]  in
            guard let self = self else {
                return
            }
            guard let currentWallet = try? self.ltcAuthFacade.getCurrentWallet() else {
                return
            }
            
            self.ltcUpdateFacade.obtainWalletHistory(
                wallet: currentWallet, skip: skip, limit: self.limit
            ) { [weak self, weak operation] result in
                guard let strongSelf = self, operation?.isCancelled == false else {
                    self?.semaphore.signal()
                    return
                }
                switch result {
                case .success(let history):
                    let walletAddress = currentWallet.address
                    
                    if strongSelf.ratesLoaded {
                        let rate = strongSelf.ltcUpdateFacade.getLocalRate()
                        let pageResponse = strongSelf.processHistoryResponse(data: history, address: walletAddress, rate: .value(rate))
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.output?.historyLoaded(responce: pageResponse)
                        }
                        
                        strongSelf.semaphore.signal()
                    } else {
                        strongSelf.ltcUpdateFacade.obtainRate { [weak self, weak operation] result in
                            guard let strongSelf = self, operation?.isCancelled == false else {
                                self?.semaphore.signal()
                                return
                            }
                            var rate: LTCHistoryRateValue = .none
                            switch result {
                            case .success(let model):
                                strongSelf.ratesLoaded = true
                                rate = .value(model.rate)
                                
                            case .failure:
                                rate = .none
                            }
                            
                            let pageResponse = strongSelf.processHistoryResponse(data: history, address: walletAddress, rate: rate)
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
    
    fileprivate func appendOriginalTransactions(transactions: [LTCWalletHistoryModel]) {
        transactions.forEach { transaction in
            originalTransactions[transaction.hash] = transaction
        }
    }
    
    private func processHistoryResponse(
        data: LTCPagedResponse<LTCWalletHistoryModel>,
        address: String,
        rate: LTCHistoryRateValue
    ) -> PagedResponse<LTCHistoryEntity> {
        appendOriginalTransactions(transactions: data.data)
        
        let entities = mapLTCTransactions(
            data: data.data,
            address: address,
            rate: rate
        )
        
        let sortedTransaction = entities.sorted {
            getDateValue(date: $0.date) > getDateValue(date: $1.date)
        }
        
        currentTransactions.append(contentsOf: sortedTransaction)
        let uniqueTransactions = removeDublicates(from: currentTransactions)
        skip = uniqueTransactions.count
        let isFull = data.totalResults <= skip
        
        return PagedResponse(isFull: isFull, data: uniqueTransactions)
    }
    
    private func removeDublicates(from models: [LTCHistoryEntity]) -> [LTCHistoryEntity] {
        var ids = Set<String>()
        var entities = [LTCHistoryEntity]()

        for item in models {
            if ids.contains(item.id) {
                continue
            }

            ids.insert(item.id)
            entities.append(item)
        }

        return entities
    }
    
    private func mapLTCTransactions(data: [LTCWalletHistoryModel], address: String, rate: LTCHistoryRateValue) -> [LTCHistoryEntity] {
        var entities = [LTCHistoryEntity]()
        let ltcSymbol = Constants.LTCConstants.LTCSymbol

        for transaction in data {
            var satoshis: Int = 0
            transaction.outputs.forEach { output in
                if output.address == address {
                    satoshis += output.satoshis
                }
            }
            let isReceiving = detectIsReceiving(inputs: transaction.inputs, address: address)
            let formattedAmount: NSAttributedString
            
            var amount = emptyBalanceString
            
            if isReceiving {
                amount = countReceivingAmount(transaction.outputs, address: address)
                formattedAmount = mapAttributedStringForReceive(symbol: ltcSymbol, amount: amount.toFormattedCropNumber())
            } else {
                amount = countSendingAmount(transaction.outputs, address: address)
                formattedAmount = mapAttributedStringForSend(symbol: ltcSymbol, amount: amount.toFormattedCropNumber())
            }
            
            var rateValue = String()
            
            if case let .value(rate) = rate {
                rateValue = usdCurrency.symbol +
                    BigDecimalNumber(amount).toFormattedCropNumber(multiplier: rate, precision: usdCurrency.decimals)
            }
            
            let entity = LTCHistoryEntity(id: transaction.hash,
                                          date: toFormattedDate(date: transaction.blockTime),
                                          amountFormatted: formattedAmount,
                                          isReceiving: isReceiving,
                                          rate: rateValue)

            entities.append(entity)
        }

        return entities
    }
    
    private func countReceivingAmount(_ outputs: [LTCWalletTransactionOutputModel], address: String) -> String {
        var satoshi: Int = 0
        outputs.forEach { output in
            if address == output.address {
                satoshi += output.satoshis
            }
        }
        return satoshiToLTC(satoshi: String(satoshi))
    }
    
    private func countSendingAmount(_ outputs: [LTCWalletTransactionOutputModel], address: String) -> String {
        var satoshi: Int = 0
        outputs.forEach { output in
            if address != output.address {
                satoshi += output.satoshis
            }
        }
        return satoshiToLTC(satoshi: String(satoshi))
    }
    
    private func detectIsReceiving(inputs: [LTCWalletTransactionInputModel], address: String) -> Bool {
        var isReceiving = true
        inputs.forEach { input in
            if input.address == address {
                isReceiving = false
            }
        }
        return isReceiving
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
    
    private func satoshiToLTC(satoshi: String) -> String {
        return BigDecimalNumber(satoshi).powerOfMinusTen(BigDecimalNumber(Constants.LTCConstants.LTCDecimal))
    }
}

// MARK: - AuthEventDelegate

extension HistoryInteractor: AuthEventDelegate {
    func didNewWalletSelected() {
        output.didNewWalletSelected()
    }
    
    func didAuthCompleted() {
    }
}
