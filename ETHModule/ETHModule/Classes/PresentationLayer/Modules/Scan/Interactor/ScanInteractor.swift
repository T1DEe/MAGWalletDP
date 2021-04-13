//
//  ScanScanInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class ScanInteractor {
    weak var output: ScanInteractorOutput!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var transferService: ETHTransferService!
}

// MARK: - ScanInteractorInput

extension ScanInteractor: ScanInteractorInput {
    func parceEthScan(string: String) -> ScanEntity {
        let groups = groupsMatches(for: "^(?:(.*):)?([^\\?]*)", string: string)
        let flatedGroups = groups.flatMap { $0 }
        
        guard let currency = flatedGroups[safe: 1] else {
            return ScanEntity(currency: nil, toAddress: nil, contractAddress: nil, amount: nil, decimals: nil)
        }
        guard let toAddress = flatedGroups[safe: 2] else {
            return ScanEntity(currency: currency, toAddress: nil, contractAddress: nil, amount: nil, decimals: nil)
        }
        
        guard isValidETHAddress(toAddress ?? "") else {
            DispatchQueue.main.async { [weak self] in
                self?.output.didFailScan()
            }
            return ScanEntity(currency: currency, toAddress: nil, contractAddress: nil, amount: nil, decimals: nil)
        }
        
        let parameters = parseParameters(string: string)
        var amount: String?
        var contractAddress: String?
        var decimals: String?
        
        if let foundedAmount = parameters["amount"] {
            amount = parseAmount(amount: foundedAmount)
        }
        
        if let value = parameters["value"] {
            amount = parseValue(value: value)
        }
        
        if let decimal = parameters["decimal"] {
            decimals = decimal
        }
        
        if let tokenAddress = parameters["contractAddress"] {
            contractAddress = tokenAddress
        }
        
        return ScanEntity(
            currency: currency,
            toAddress: toAddress,
            contractAddress: contractAddress,
            amount: amount,
            decimals: decimals
        )
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func isValidETHAddress(_ ethAddress: String) -> Bool {
        return transferService.isValidAddress(ethAddress)
    }
    
    private func groupsMatches(for regexPattern: String, string: String) -> [[String?]] {
        let nsString = NSString(string: string)
        guard let regex = try? NSRegularExpression(pattern: regexPattern) else {
            return []
        }

        let matches = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))

        return matches.map { match in
            (0..<match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: string) else {
                    return nil
                }
                return String(string[range])
            }
        }
    }
    
    private func parseParameters(string: String) -> [String: String] {
        var parameters = [String: String]()
        guard let parametersIndex = string.firstIndex(of: "?") else {
            return parameters
        }
        let parametersString = String(string[parametersIndex..<string.endIndex].dropFirst())
        for pair in parametersString.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair
                .components(separatedBy: "=")[1]
                .replacingOccurrences(of: "+", with: "")
                .removingPercentEncoding ?? ""

            parameters[key] = value
        }

        return parameters
    }
    
    private func parseValue(value: String) -> String {
        if value.contains("e") {
            let wei = BigDecimalNumber(value).reduceENotation()
            return BigDecimalNumber(wei).powerOfMinusTen(BigDecimalNumber(Constants.ETHConstants.ETHDecimal))
        }
        
        return BigDecimalNumber(value).powerOfMinusTen(BigDecimalNumber(Constants.ETHConstants.ETHDecimal))
    }
    
    private func parseAmount(amount: String) -> String {
        if amount.contains("e") {
            let eth = BigDecimalNumber(amount).reduceENotation()
            return eth
        }
        
        return amount
    }
}
