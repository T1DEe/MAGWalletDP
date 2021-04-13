//
//  ScanScanInteractor.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class ScanInteractor {
    weak var output: ScanInteractorOutput!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var transferService: LTCTransferService!
}

// MARK: - ScanInteractorInput

extension ScanInteractor: ScanInteractorInput {
    func parceLTCScan(string: String) -> ScanEntity {
        let groups = groupsMatches(for: "^(?:(.*):)?([^\\?]*)", string: string)
        let flatedGroups = groups.flatMap { $0 }
        
        guard let toAddress = flatedGroups[safe: 2] else {
            return ScanEntity(toAddress: nil, amount: nil)
        }
        
        let parameters = parseParameters(string: string)
        
        guard isValidLTCAddress(toAddress ?? "") else {
            DispatchQueue.main.async { [weak self] in
                self?.output.didFailScan()
            }
            return ScanEntity(toAddress: nil, amount: nil)
        }
        
        guard let amount = parameters["amount"] else {
            return ScanEntity(toAddress: toAddress, amount: nil)
        }
        
        return ScanEntity(toAddress: toAddress, amount: amount)
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func isValidLTCAddress(_ ltcAddress: String) -> Bool {
        return transferService.isValidAddress(ltcAddress)
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
}
