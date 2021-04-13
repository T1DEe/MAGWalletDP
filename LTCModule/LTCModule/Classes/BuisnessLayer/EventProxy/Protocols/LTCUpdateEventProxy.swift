//
//  LTCUpdateEventProxy.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol LTCUpdateEventDelegate: class {
    func didUpdateBalance()
}

extension LTCUpdateEventDelegate {
    func didUpdateBalance() {}
}

protocol LTCUpdateEventActionHandler {
    func actionUpdateBalance()
}

protocol LTCUpdateEventDelegateHandler {
    var delegate: LTCUpdateEventDelegate? { get set }
}

protocol LTCUpdateEventProxy: LTCUpdateEventDelegateHandler, LTCUpdateEventActionHandler { }
