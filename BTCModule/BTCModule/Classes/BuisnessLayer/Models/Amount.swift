//
//  Amount.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

struct Amount: Codable {
    let value: String
    let decimals: Int
    
    var valueWithDecimals: String {
        return calculateValueWithDecimals()
    }
    
    var uintValue: UInt {
        return UInt(value) ?? 0
    }
    
    init(value: String, decimals: Int) {
        self.value = value
        self.decimals = decimals
    }
    
    init(userFrendlyValue: String, decimals: Int) {
        let stringValue = userFrendlyValue.replacingOccurrences(of: ",", with: ".")
        let value = BigDecimalNumber(stringValue)
        let valueDecimal = BigDecimalNumber(decimals)
        
        self.value = value.powerOfTen(valueDecimal)
        self.decimals = decimals
    }
    
    func isEqualToZero() -> Bool {
        let zero = BigDecimalNumber("0")
        let value = BigDecimalNumber(self.value)
        
        return value == zero
    }
    
    private func calculateValueWithDecimals() -> String {
        let value = BigDecimalNumber(self.value)
        let valueDecimal = BigDecimalNumber(decimals)
        
        return value.powerOfMinusTen(valueDecimal)
    }
}
