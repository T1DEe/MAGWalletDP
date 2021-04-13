//
//  FirebaseEventProxyImp.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class FirebaseTokenEventProxyImp: FirebaseTokenEventProxy {
    weak var delegate: FirebaseTokenEventDelegate?
    
    func actionChangeFirebaseToken(newToken: String, previousToken: String?) {
        delegate?.firebaseTokenDidChange(newToken: newToken, previousToken: previousToken)
    }
}
