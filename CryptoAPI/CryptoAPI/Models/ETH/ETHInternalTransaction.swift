//
//  ETHInternalTransaction.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct ETHInternalTransaction {
    public let to: String
    public let from: String
    public let value: String
    public let input: String
    public let isSuicide: Bool
    public let type: String
}

extension ETHInternalTransaction: Codable {
    enum CodingKeys: String, CodingKey {
        case to
        case from
        case value
        case input
        case isSuicide = "is_suicide"
        case type
    }
}
