//
//  BTCUpdateEventProxy.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol BTCUpdateEventDelegate: class {
    func didUpdateBalance()
}

extension BTCUpdateEventDelegate {
    func didUpdateBalance() {}
}

protocol BTCUpdateEventActionHandler {
    func actionUpdateBalance()
}

protocol BTCUpdateEventDelegateHandler {
    var delegate: BTCUpdateEventDelegate? { get set }
}

protocol BTCUpdateEventProxy: BTCUpdateEventDelegateHandler, BTCUpdateEventActionHandler { }
