//
//  AuthEventProxy.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol AuthEventDelegate: class {
    func didAuthAction()
    func didLogoutAction()
}

protocol AuthEventDelegateHandler: class {
    var delegate: AuthEventDelegate? { get set }
}

protocol AuthEventActionHandler {
    func actionAuth()
    func actionLogout()
}

protocol AuthEventProxy: AuthEventActionHandler, AuthEventDelegateHandler {
}
