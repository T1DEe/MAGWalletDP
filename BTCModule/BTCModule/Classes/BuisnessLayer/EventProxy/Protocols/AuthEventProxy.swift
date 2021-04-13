//
//  AuthEventProxy.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol AuthEventDelegate: class {
    func didAuthCompleted()
    func didNewWalletSelected()
}

protocol AuthEventDelegateHandler: class {
    var delegate: AuthEventDelegate? { get set }
}

protocol AuthEventActionHandler {
    func actionAuthCompleted()
    func actionNewWalletSelected()
}

protocol AuthEventProxy: AuthEventActionHandler, AuthEventDelegateHandler {
}
