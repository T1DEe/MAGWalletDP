//
//  HistoryDetailsHistoryDetailsInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import UIKit

class HistoryDetailsInteractor {
    weak var output: HistoryDetailsInteractorOutput!
    var btcAuthFacade: BTCAuthService!
    var networkFacade: BTCNetworkFacade!
    var transaction: BTCWalletHistoryModel!
}

// MARK: - HistoryDetailsInteractorInput

extension HistoryDetailsInteractor: HistoryDetailsInteractorInput {
    func setTransaction(_ transaction: BTCWalletHistoryModel) {
        self.transaction = transaction
    }
    
    func getScreenModel() -> HistoryDetailsScreenModel {
        let currentAddress = getCurrentAddress()
        let date = toFormattedDate(date: transaction.blockTime)
        let isConfirmed: Bool
        let blockHash = transaction.blockHash
        if blockHash.isEmpty {
            isConfirmed = false
        } else {
            isConfirmed = true
        }
        let isReceiving = detectIsReceiving(inputs: transaction.inputs, address: currentAddress)
        let formattedAmount: NSAttributedString
        if isReceiving {
            let receivingAmount = countReceivingAmount(transaction.outputs, address: currentAddress)
            formattedAmount = mapAttributedStringForAmount(symbol: Constants.BTCConstants.BTCSymbol,
                                                           amount: receivingAmount.toFormattedCropNumber(),
                                                           amountFontSize: 20,
                                                           symbolFontSize: 12,
                                                           isReceive: nil)
        } else {
            let sendingAmount = countSendingAmount(transaction.outputs, address: currentAddress)
            formattedAmount = mapAttributedStringForAmount(symbol: Constants.BTCConstants.BTCSymbol,
            amount: sendingAmount.toFormattedCropNumber(),
            amountFontSize: 20,
            symbolFontSize: 12,
            isReceive: nil)
        }

        let details = mapDetails(isReceiving: isReceiving)
        
        let model = HistoryDetailsScreenModel(date: date,
                                              amount: formattedAmount,
                                              isConfirmed: isConfirmed,
                                              details: details)
        return model
    }
    
    func getExplorerUrl(type: HistoryDetailsExplorerType) -> URL? {
        let explorerUrl = getExplorerUrl()
        
        switch type {
        case .transaction:
            return URL(string: "\(explorerUrl)/tx/\(transaction.hash)")
            
        case .address(let address):
            return URL(string: "\(explorerUrl)/address/\(address)")
            
        case .block:
            return URL(string: "\(explorerUrl)/block/\(transaction.blockHash)")
        }
    }
    
    // MARK: - Private
    
    private func getExplorerUrl() -> String {
        switch networkFacade.getCurrentNetwork() {
        case .mainnet:
            return Constants.BTCExplorers.mainnet
            
        case .testnet:
            return Constants.BTCExplorers.testnet
        }
    }
    
    private func mapDetails(isReceiving: Bool) -> [HistoryDetailsDetailScreenModel] {
        let currentAddress = getCurrentAddress()
        let fee = String(transaction.fee)
        let feeAmount = satoshiToBTC(satoshi: fee)
        let formattedFee = mapAttributedStringForAmount(symbol: Constants.BTCConstants.BTCSymbol,
                                                        amount: feeAmount.toFormattedCropNumber(),
                                                        amountFontSize: 20,
                                                        symbolFontSize: 12,
                                                        isReceive: nil)
        let blockHeight = String(transaction.blockHeight)
        let formattedBlockHeight = mapAttributedStringForAmount(symbol: "",
                                                                amount: "#" + blockHeight,
                                                                amountFontSize: 20,
                                                                symbolFontSize: 0,
                                                                isReceive: nil)
        
        let fromAddress: String
        let toAddress: String
        if isReceiving {
            let inputAddress = transaction.inputs[0].address
            fromAddress = inputAddress
            toAddress = currentAddress
        } else {
            fromAddress = currentAddress
            let firstOutput = transaction.outputs.first { output -> Bool in
                output.address != currentAddress
            }
            toAddress = firstOutput?.address ?? ""
        }
        
        let blockHeightModel = HistoryDetailsAmountDetailScreenModel(title: R.string.localization.historyDetailsBlock(),
                                                                     amountValue: formattedBlockHeight,
                                                                     type: .block)
        
        let feeModel = HistoryDetailsAmountDetailScreenModel(title: R.string.localization.historyDetailsFee(),
                                                             amountValue: formattedFee,
                                                             type: .fee)
        
        let toAddressModel = HistoryDetailsTextDetailScreenModel(title: R.string.localization.historyDetailsTo(),
                                                                 value: toAddress)
        
        let fromAddressModel = HistoryDetailsTextDetailScreenModel(title: R.string.localization.historyDetailsFrom(),
                                                                   value: fromAddress)
        
        return [blockHeightModel, fromAddressModel, toAddressModel, feeModel]
    }
    
    private func countReceivingAmount(_ outputs: [BTCWalletTransactionOutputModel], address: String) -> String {
        var satoshi: Int = 0
        outputs.forEach { output in
            if address == output.address {
                satoshi += output.satoshis
            }
        }
        return satoshiToBTC(satoshi: String(satoshi))
    }
    
    private func countSendingAmount(_ outputs: [BTCWalletTransactionOutputModel], address: String) -> String {
        var satoshi: Int = 0
        outputs.forEach { output in
            if address != output.address {
                satoshi += output.satoshis
            }
        }
        return satoshiToBTC(satoshi: String(satoshi))
    }
    
    private func detectIsReceiving(inputs: [BTCWalletTransactionInputModel], address: String) -> Bool {
        var isReceiving = true
        inputs.forEach { input in
            if input.address == address {
                isReceiving = false
            }
        }
        return isReceiving
    }
    
    private func getCurrentAddress() -> String {
        guard let currentWallet = try? btcAuthFacade.getCurrentWallet() else {
            return ""
        }
        return currentWallet.address
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
    
    private func satoshiToBTC(satoshi: String) -> String {
        return BigDecimalNumber(satoshi).powerOfMinusTen(BigDecimalNumber(Constants.BTCConstants.BTCDecimal))
    }
}
