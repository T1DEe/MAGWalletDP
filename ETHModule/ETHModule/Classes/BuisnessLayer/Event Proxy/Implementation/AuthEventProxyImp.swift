//
//  AuthEventProxyImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class AuthEventProxyImp: AuthEventProxy {
    weak var delegate: AuthEventDelegate? {
        didSet {
            authDelegates.addObject(delegate)
        }
    }
    
    private var authDelegates = NSPointerArray.weakObjects()
    
    func actionAuthCompleted() {
        authDelegates.compact()
        
        for index in 0..<authDelegates.count {
            if let delegate = authDelegates.object(at: index) as? AuthEventDelegate {
                delegate.didAuthCompleted()
            }
        }
    }
    
    func actionNewWalletSelected() {
        authDelegates.compact()
        
        for index in 0..<authDelegates.count {
            if let delegate = authDelegates.object(at: index) as? AuthEventDelegate {
                delegate.didNewWalletSelected()
            }
        }
    }
}
