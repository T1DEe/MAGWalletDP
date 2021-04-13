//
//  HistoryDetailsInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import UIKit

class HistoryDetailsInteractor {
    weak var output: HistoryDetailsInteractorOutput!
    var ethAuthFacade: ETHAuthService!
    var settingsConfiguration: ETHSettingsConfiguration!
    
    var historyTransaction: ETHWalletHistoryEntity?
    var tokenTransaction: TokenHistoryEntity?
}

// MARK: - HistoryDetailsInteractorInput

extension HistoryDetailsInteractor: HistoryDetailsInteractorInput {
    func setTransaction(_ transaction: ETHWalletHistoryEntity) {
        self.historyTransaction = transaction
    }
    
    func setTransaction(_ transaction: TokenHistoryEntity) {
        self.tokenTransaction = transaction
    }
    
    func getScreenModel() -> HistoryDetailsScreenModel? {
        if let transaction = historyTransaction {
            return getScreenModel(for: transaction)
        }
        if let transaction = tokenTransaction {
            return getScreenModel(for: transaction)
        }
        return .none
    }
    
    func getUrlWithTransactionHash() -> URL? {
        var hashComponent = String()
        
        if let hash = historyTransaction?.hash {
            hashComponent = hash
        }
        if let hash = tokenTransaction?.original.transactionHash {
            hashComponent = hash
        }
        
        let url = URL(string: "\(Constants.ETHExplorerUrl.rinkeby)/tx/\(hashComponent)")

        return url
    }

    func getUrlWithAddress(address: String) -> URL? {
        let url = URL(string: "\(Constants.ETHExplorerUrl.rinkeby)/address/\(address)")

        return url
    }
    
    // MARK: Private
    
    private func getScreenModel(for transaction: ETHWalletHistoryEntity) -> HistoryDetailsScreenModel {
        let date = toFormattedDate(date: transaction.creationFullDate)
        let isConfirmed = transaction.isConfirmed
        
        var value = transaction.value
        if let internalTransaction = transaction.internalTransaction {
            value = internalTransaction.value
        }
        
        let amount = Amount(value: value, decimals: Constants.ETHConstants.ETHDecimal)
        let formattedAmount = mapAttributedStringForAmount(symbol: Constants.ETHConstants.ETHSymbol,
                                                           amount: amount.valueWithDecimals.toFormattedCropNumber(),
                                                           amountFontSize: 22,
                                                           symbolFontSize: 16,
                                                           isReceive: transaction.isReceive)
        
        let details = mapDetails(for: transaction)
        
        let model = HistoryDetailsScreenModel(date: date,
                                              amount: formattedAmount,
                                              isConfirmed: isConfirmed,
                                              details: details)
        return model
    }
    
    private func getScreenModel(for transaction: TokenHistoryEntity) -> HistoryDetailsScreenModel {
        let date = toFormattedDate(date: transaction.original.timestamp)
        // Cause always confirmed
        let isConfirmed = true
        
        let decimals = transaction.tokenCurrency.decimals
        let amount = BigDecimalNumber(hex: transaction.original.value).powerOfMinusTen(BigDecimalNumber(decimals))
        
        let formattedAmount = mapAttributedStringForAmount(symbol: transaction.tokenCurrency.symbol,
                                                           amount: amount.toFormattedCropNumber(),
                                                           amountFontSize: 22,
                                                           symbolFontSize: 16,
                                                           isReceive: transaction.isReceive)
        let details = mapDetails(for: transaction.original)
        
        let model = HistoryDetailsScreenModel(date: date, amount: formattedAmount, isConfirmed: isConfirmed, details: details)
        
        return model
    }
    
    private func mapDetails(for transaction: ETHWalletHistoryEntity) -> [HistoryDetailsDetailScreenModel] {
        let fee = countFee(transaction: transaction)
        let formattedFee = mapAttributedStringForAmount(symbol: Constants.ETHConstants.ETHSymbol,
                                                        amount: fee.valueWithDecimals.toFormattedCropNumber(),
                                                        amountFontSize: 20,
                                                        symbolFontSize: 12,
                                                        isReceive: nil)
        
        var toAddress = transaction.toAddress
        var fromAddress = transaction.fromAddress
        if let internalTransaction = transaction.internalTransaction {
            toAddress = internalTransaction.to
            fromAddress = internalTransaction.from
        }
        
        let feeModel = HistoryDetailsAmountDetailScreenModel(title: R.string.localization.historyDetailsFee(),
                                                             amountValue: formattedFee)
        
        let fromAddressModel = HistoryDetailsTextDetailScreenModel(title: R.string.localization.historyDetailsFrom(),
                                                                   value: fromAddress)
        
        if let toAddress = toAddress {
            let toAddressModel = HistoryDetailsTextDetailScreenModel(title: R.string.localization.historyDetailsTo(),
                                                                     value: toAddress)
            
            return [feeModel, toAddressModel, fromAddressModel]
        } else {
            return [feeModel, fromAddressModel]
        }
    }
    
    private func mapDetails(for transaction: ETHWalletTokenHistoryEntity) -> [HistoryDetailsDetailScreenModel] {
        let toAddressModel = HistoryDetailsTextDetailScreenModel(
            title: R.string.localization.historyDetailsTo(),
            value: transaction.toAddress
        )
        let fromAddressModel = HistoryDetailsTextDetailScreenModel(
            title: R.string.localization.historyDetailsFrom(),
            value: transaction.fromAddress
        )
        
        return [toAddressModel, fromAddressModel]
    }
    
    private func mapAttributedStringForAmount(symbol: String,
                                              amount: String,
                                              amountFontSize: CGFloat,
                                              symbolFontSize: CGFloat,
                                              isReceive: Bool?) -> NSAttributedString {
        var receiveSymbol = String()
        if let isReceive = isReceive {
            receiveSymbol = isReceive ? "+ " : "- "
        }
        
        let amountFont = R.font.poppinsMedium(size: amountFontSize) ?? UIFont.systemFont(ofSize: amountFontSize)
        let amountColor = R.color.dark() ?? .black
        let amount = NSMutableAttributedString(
            string: receiveSymbol + amount + " ",
            attributes: [
                NSAttributedString.Key.font: amountFont,
                NSAttributedString.Key.foregroundColor: amountColor
            ]
        )
        
        let symbolFont = R.font.poppinsMedium(size: symbolFontSize) ?? UIFont.systemFont(ofSize: symbolFontSize)
        let symbolColor = R.color.gray1() ?? .gray
        let symbolAttributed = NSMutableAttributedString(
            string: symbol,
            attributes: [
                NSAttributedString.Key.font: symbolFont,
                NSAttributedString.Key.foregroundColor: symbolColor
            ]
        )
        
        amount.append(symbolAttributed)
        
        return amount
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
    
    private func countFee(transaction: ETHWalletHistoryEntity) -> Amount {
        let gasPrice = BigDecimalNumber(transaction.gasPrice)
        let gasUsed = BigDecimalNumber(transaction.gasUsed)
        let fee = Amount(value: (gasPrice * gasUsed).stringValue, decimals: Constants.ETHConstants.ETHDecimal)
        return fee
    }
}
