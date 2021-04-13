//
//  Dictionary+Extension.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

extension Dictionary where Key: CustomStringConvertible, Value: CustomStringConvertible {
    func stringFromHttpParameters() -> String {
        var parametersString = "?"
        for (key, value) in self {
            parametersString += key.description + "=" + value.description + "&"
        }
        return String(parametersString.dropLast())
    }
}

extension Array where Element: StringProtocol {
    public var description: String { return self.joined(separator: ",") }
}
