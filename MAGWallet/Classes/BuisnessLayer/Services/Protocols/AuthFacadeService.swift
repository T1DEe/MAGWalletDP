//
//  AuthFacade.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

protocol AuthFacade: Clearable {
    var hashOfPin: String? { get }

    func storePin(pin: String) throws
    func verify(pin: String) -> Bool
    func changePin(newPin: String, oldPin: String) throws
}
