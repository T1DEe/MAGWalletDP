//
//  BytecodeCoreComponent.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

protocol BytecodeCoreComponent {
    func sendTokenBytecode(address: String, value: String) -> String?
}
