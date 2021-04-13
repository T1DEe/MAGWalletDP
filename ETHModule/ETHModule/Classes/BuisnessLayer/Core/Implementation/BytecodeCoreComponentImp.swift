//
//  BytecodeCoreComponentImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import BigInt

final class BytecodeCoreComponentImp: BytecodeCoreComponent {
    func sendTokenBytecode(address: String, value: String) -> String? {
        let method = "0xa9059cbb"
        let addressHex = address.replacingOccurrences(of: "0x", with: "")
        let addressFull = String(repeating: "0", count: 64 - addressHex.count) + addressHex
        
        let valueUInt = BigUInt(stringLiteral: value)
        let data = valueUInt.solidityData
        let valueFull = data.hex
        
        return method + addressFull + valueFull
    }
}
