//
//  BigDecimalNumber.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BigNumber
import Foundation

public struct BigDecimalNumber: Codable {
    private let precisionConstant = 50
    
    public var stringValue: String {
        let fractionDescription = container.fractionDescription
        if fractionDescription.contains("/") {
            return container.decimalExpansion(precisionAfterDecimalPoint: precisionConstant, rounded: true)
        } else {
            return fractionDescription
        }
    }
    
    public var intValue: Int? {
        return Int(container.rounded().description)
    }
    
    private var container: BDouble
    
    public init(_ string: String) {
        let formattedString = string.replacingOccurrences(of: ",", with: ".")
        let decimalContainer = BDouble(formattedString) ?? BDouble(0)
        container = decimalContainer
    }
    
    private init(container: BDouble) {
        self.container = container
    }
    
    public init(_ int: Int) {
        let decimalContainer = BDouble(int)
        container = decimalContainer
    }
    
    public init(hex: String) {
        container = BDouble(hex, radix: 16) ?? BDouble(0)
    }
    
    public func stringValue(precisionAfterDecimalPoint: Int, rounded: Bool = true) -> String {
        return container.decimalExpansion(precisionAfterDecimalPoint: precisionAfterDecimalPoint, rounded: rounded)
    }
    
    public func absoluteValue() -> BigDecimalNumber {
        return BigDecimalNumber(container.rounded().description)
    }
    
    public func add(_ other: BigDecimalNumber) -> BigDecimalNumber {
        let value = self
        let result = value.container + other.container
        return BigDecimalNumber(container: result)
    }
    
    public func subtract(_ other: BigDecimalNumber) -> BigDecimalNumber {
        let value = self
        let result = value.container - other.container
        return BigDecimalNumber(container: result)
    }
    
    public func multiply(_ other: BigDecimalNumber) -> BigDecimalNumber {
        let value = self
        let result = value.container * other.container
        return BigDecimalNumber(container: result)
    }
    
    public func divide(_ other: BigDecimalNumber) -> BigDecimalNumber {
        let value = self
        let result = value.container / other.container
        return BigDecimalNumber(container: result)
    }
    
    public func abs() -> BigDecimalNumber {
        if container.isNegative() {
            let result = container * -1
            return BigDecimalNumber(container: result)
        }
        
        return self
    }
    
    public func powerOfTen(_ power: BigDecimalNumber) -> String {
        guard let value = BDouble(stringValue) else {
            return "0"
        }
        
        let ten = BDouble(10)
        let power = power.intValue ?? 0
        
        let multiplier = ten ** power
        let result = value * multiplier
        var resultString = result.decimalExpansion(precisionAfterDecimalPoint: precisionConstant)
        let zeroRange = resultString.range(of: "[.]?0+$", options: .regularExpression, range: nil, locale: nil)
        
        if let zeroRange = zeroRange {
            resultString.removeSubrange(zeroRange)
        }
        
        return resultString
    }
    
    public func reduceENotation() -> String {
        guard let value = BDouble(stringValue) else {
            return "0"
        }
        var resultString = value.decimalExpansion(precisionAfterDecimalPoint: precisionConstant)
        let zeroRange = resultString.range(of: "[.]?0+$", options: .regularExpression, range: nil, locale: nil)
        
        if let zeroRange = zeroRange {
            resultString.removeSubrange(zeroRange)
        }
        return resultString
    }
    
    public func convertToENotation() -> String {
        guard let bDouble = BDouble(stringValue) else {
            return "0"
        }
        var value = bDouble.decimalExpansion(precisionAfterDecimalPoint: precisionConstant)
        let zeroRange = value.range(of: "[.]?0+$", options: .regularExpression, range: nil, locale: nil)
        
        if let zeroRange = zeroRange {
            value.removeSubrange(zeroRange)
        }
        
        guard value.count != 1 else {
            return value + ".0e0"
        }
        
        guard !value.contains("-") else {
            return "0"
        }
        
        var eValue = value
        let pointIndex = eValue.index(eValue.startIndex, offsetBy: 1)
        eValue.insert(".", at: pointIndex)
        
        return eValue + "e\(value.count - 1)"
    }
    
    public func powerOfMinusTen(_ power: BigDecimalNumber) -> String {
        let minusPower = power * BigDecimalNumber(-1)
        return powerOfTen(minusPower)
    }
    
    public func isLessOrEqual(_ other: BigDecimalNumber) -> Bool {
        return container <= other.container
    }
    
    public func isLess(_ other: BigDecimalNumber) -> Bool {
        return container < other.container
    }
    
    public func isGreaterOrEqual(_ other: BigDecimalNumber) -> Bool {
        return container >= other.container
    }
    
    public func isGreater(_ other: BigDecimalNumber) -> Bool {
        return container > other.container
    }
    
    public func isEqual(_ other: BigDecimalNumber) -> Bool {
        return container == other.container
    }
    
    public func roundToInt() -> BigDecimalNumber {
        return round(0)
    }
    
    public func round(_ toValue: Int16) -> BigDecimalNumber {
        let value = NSDecimalNumber(string: stringValue)
        
        let behaviour = NSDecimalNumberHandler(roundingMode: .plain,
                                               scale: toValue,
                                               raiseOnExactness: false,
                                               raiseOnOverflow: false,
                                               raiseOnUnderflow: false,
                                               raiseOnDivideByZero: false)
        
        return BigDecimalNumber(value.rounding(accordingToBehavior: behaviour).stringValue)
    }
    
    enum CodingKeys: String, CodingKey { case stringValue }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stringValue = try container.decode(String.self, forKey: .stringValue)
        self.init(stringValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stringValue, forKey: .stringValue)
    }
    
    public static func maxBigNumberWithPowerOfTwo(power: Int, isUnsigned: Bool) -> BigDecimalNumber {
        let value: String
        
        switch power {
        case 256:
            value = isUnsigned ?
                "115792089237316195423570985008687907853269984665640564039457584007913129639935" :
            "57896044618658097711785492504343953926634992332820282019728792003956564819967"
        case 128:
            value = isUnsigned ?
                "340282366920938463463374607431768211455" :
            "170141183460469231731687303715884105727"
        case 96:
            value = isUnsigned ?
                "79228162514264337593543950335" :
            "39614081257132168796771975167"
        case 64:
            value = isUnsigned ?
                "18446744073709551615" :
            "9223372036854775807"
        case 48:
            value = isUnsigned ?
                "281474976710655" :
            "140737488355327"
        case 32:
            value = isUnsigned ?
                "4294967295" :
            "2147483647"
        case 24:
            value = isUnsigned ?
                "16777215" :
            "8388607"
        case 16:
            value = isUnsigned ?
                "65535" :
            "32767"
        case 8:
            value = isUnsigned ?
                "255" :
            "127"
        case 4:
            value = isUnsigned ?
                "15" :
            "7"
        default:
            value = isUnsigned ?
                "18446744073709551615" :
            "9223372036854775807"
        }
        
        return BigDecimalNumber(value)
    }
    
    public static func minBigNumberWithPowerOfTwo(power: Int) -> BigDecimalNumber {
        let value: String
        
        switch power {
        case 256:
            value = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
        case 128:
            value = "-170141183460469231731687303715884105726"
        case 96:
            value = "-39614081257132168796771975166"
        case 64:
            value = "-9223372036854775807"
        case 48:
            value = "-140737488355327"
        case 32:
            value = "-2147483647"
        case 24:
            value = "-8388607"
        case 16:
            value = "-32767"
        case 8:
            value = "-127"
        case 4:
            value = "-7"
        default:
            value = "-9223372036854775807"
        }
        
        return BigDecimalNumber(value)
    }
}

// MARK: - Arithmetic Operators

public func + (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> BigDecimalNumber {
    return lhs.add(rhs)
}

public func / (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> BigDecimalNumber {
    return lhs.divide(rhs)
}

public func * (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> BigDecimalNumber {
    return lhs.multiply(rhs)
}

public func - (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> BigDecimalNumber {
    return lhs.subtract(rhs)
}

public func -= (lhs: inout BigDecimalNumber, rhs: BigDecimalNumber) {
    lhs = lhs.subtract(rhs)
}

public func += (lhs: inout BigDecimalNumber, rhs: BigDecimalNumber) {
    lhs = lhs.add(rhs)
}

// MARK: -

public func > (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> Bool {
    return lhs.isGreater(rhs)
}

public func >= (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> Bool {
    return lhs.isGreaterOrEqual(rhs)
}

public func <= (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> Bool {
    return lhs.isLessOrEqual(rhs)
}

public func < (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> Bool {
    return lhs.isLess(rhs)
}

public func == (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> Bool {
    return lhs.isEqual(rhs)
}

public func != (lhs: BigDecimalNumber, rhs: BigDecimalNumber) -> Bool {
    return !lhs.isEqual(rhs)
}
