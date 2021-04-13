//
//  ETHUpdateEventProxy.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

protocol ETHUpdateEventDelegate: class {
    func didUpdateBalance()
}

extension ETHUpdateEventDelegate {
    func didUpdateBalance() {}
}

protocol ETHUpdateEventActionHandler {
    func actionUpdateBalance()
}

protocol ETHUpdateEventDelegateHandler {
    var delegate: ETHUpdateEventDelegate? { get set }
}

protocol ETHUpdateEventProxy: ETHUpdateEventDelegateHandler, ETHUpdateEventActionHandler { }
