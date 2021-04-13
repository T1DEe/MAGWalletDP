//
//  CryptoCoreComponent.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

protocol CryptoCoreComponent {
    func hash(string: String) -> String
    func encrypt(string: String, salt: String) throws -> String
    func decrypt(hash: String, salt: String) throws -> String
}
