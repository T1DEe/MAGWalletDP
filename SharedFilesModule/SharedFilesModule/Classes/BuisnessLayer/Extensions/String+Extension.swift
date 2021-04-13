//
//  String+Extension.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import CommonCrypto
import Foundation

public extension String {
    func toFormattedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let parts = components(separatedBy: ".")
        guard let integerPart = parts[safe: 0] else {
            return self
        }
        let integerPartWithCommas = String(integerPart.reversed()).separate(every: 3, with: formatter.groupingSeparator)
        
        guard let fractionalPart = parts[safe: 1] else {
            return String(integerPartWithCommas.reversed())
        }
        
        let separatedFractionalPart = fractionalPart.separate(every: 3, with: formatter.groupingSeparator)
        
        return String(integerPartWithCommas.reversed()) + formatter.decimalSeparator + separatedFractionalPart
    }
    
    func toLocaleSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let localeDecimal = self
            .replacingOccurrences(of: ".", with: formatter.decimalSeparator)
            .replacingOccurrences(of: ",", with: formatter.decimalSeparator)
        return localeDecimal
    }
    
    func toFormattedBlocks() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let separatedValue = String(self.reversed()).separate(every: 3, with: " ")
        
        return String(separatedValue.reversed())
    }
    
    static func randomString(length: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = letters.length
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = Int.random(in: 0..<len)
            var nextChar = letters.character(at: rand)
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    fileprivate func separate(every: Int, with separator: String) -> String {
        var resultString = String()

        for index in 0..<self.count {
            if index != 0, index % 3 == 0 {
                resultString.append(Character(separator))
                resultString.append(self[index])
            } else {
                resultString.append(self[index])
            }
        }
        
        return resultString
    }
    
    subscript (index: Int) -> String {
        return String(Array(self)[index])
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: range.lowerBound)
        let idx2 = index(startIndex, offsetBy: range.upperBound)
        return String(self[idx1..<idx2])
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, bounds.lowerBound))
        let end = index(startIndex, offsetBy: min(count, min(count, bounds.upperBound)))
        return String(self[start...end])
    }
}

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.first { $0.isASCII }?.value
    }
    
    func unicodeScalarCodePoint() -> Int {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return Int(scalars[scalars.startIndex].value)
    }
}

public extension String {
    func toFormattedCropNumber(_ precision: Int = 8) -> String {
        let cropped = cropFractionalPart(to: precision)
        let formatted = cropped.toFormattedNumber()
        return formatted
    }
    
    private func cropFractionalPart(to precision: Int) -> String {
        let parts = components(separatedBy: ".")
        guard let integerPart = parts[safe: 0], let fractionalPart = parts[safe: 1], precision != 0 else {
            return self
        }
        
        var wasNumberAboveSymbols = false
        var newFractional = String()
        var zerosInLastString = 0
        
        for (index, character) in fractionalPart.enumerated() {
            guard let number = Int(String(character)) else {
                return self
            }
            if number > 0 {
                if index < precision {
                    wasNumberAboveSymbols = true
                }
                zerosInLastString = 0
            } else {
                zerosInLastString += 1
            }
            newFractional.append(character)
            if (index == precision - 1) && wasNumberAboveSymbols {
                break
            }
        }
        
        newFractional.removeLast(zerosInLastString)
        
        if newFractional.isEmpty {
            return integerPart
        }
        
        return integerPart + "." + newFractional
    }
}
