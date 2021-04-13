//
//  BigDecimalNumber+Extensions.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public extension BigDecimalNumber {
    func toFormattedCropNumber(multiplier: String, precision: Int, rounded: Bool = false) -> String {
        let rateDemicalNumber = BigDecimalNumber(multiplier)
        let roundedRate = self.multiply(rateDemicalNumber)
        if roundedRate.isEqual(BigDecimalNumber(0)) {
            return "0"
        } else {
            let value = BigDecimalNumber(roundedRate.stringValue(precisionAfterDecimalPoint: precision, rounded: rounded))
            return value.stringValue.toFormattedCropNumber()
        }
    }
}
