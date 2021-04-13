//
//  AuthEventProxyImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class AuthEventProxyImp: AuthEventProxy {
    weak var delegate: AuthEventDelegate? {
        didSet {
            delegates.addObject(delegate)
        }
    }
    fileprivate var delegates = NSPointerArray.weakObjects()

    func actionAuth() {
        delegates.compact()

        for index in 0..<delegates.count {
            if let delegate = delegates.object(at: index) as? AuthEventDelegate {
                delegate.didAuthAction()
            }
        }
    }

    func actionLogout() {
        delegates.compact()

        for index in 0..<delegates.count {
            if let delegate = delegates.object(at: index) as? AuthEventDelegate {
                delegate.didLogoutAction()
            }
        }
    }
}
