//
//  FirebaseTokenEventProxy.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol FirebaseTokenEventDelegate: class {
    func firebaseTokenDidChange(newToken: String, previousToken: String?)
}

protocol FirebaseTokenEventDelegateHandler: class {
    var delegate: FirebaseTokenEventDelegate? { get set }
}

protocol FirebaseTokenActionHandler {
    func actionChangeFirebaseToken(newToken: String, previousToken: String?)
}

protocol FirebaseTokenEventProxy: FirebaseTokenActionHandler, FirebaseTokenEventDelegateHandler {
}
