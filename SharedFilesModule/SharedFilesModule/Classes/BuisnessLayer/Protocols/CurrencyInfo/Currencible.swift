//
//  Currency.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public struct Currency: Equatable {
    public let id: String
    public let name: String
    public let symbol: String
    public let decimals: Int
    public let isToken: Bool
    
    public init(id: String,
                name: String,
                symbol: String,
                decimals: Int,
                isToken: Bool) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.isToken = isToken
    }
}

public extension Currency {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.symbol == rhs.symbol &&
            lhs.decimals == rhs.decimals &&
            lhs.isToken == rhs.isToken
    }
}
