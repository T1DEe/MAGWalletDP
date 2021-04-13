//
//  SessionExpireEventProxy.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol SessionTimeoutDelegate: class {
    func sessionActivityTimeout()
}

public protocol SessionTimeoutDelegateHandler: class {
    var timeoutDelegate: SessionTimeoutDelegate? { get set }
}

public protocol SessionExpirePreventActionHandler {
    func preventSeesionExpireAction()
    func startMonitoring()
    func stopMonitoring()
    func expirationTimeDidChange()
    func setLocalExpireTime(time: BlockTime)
    func removeLocalExpireTime()
    func isSessionExpire() -> Bool
}

public protocol SessionExpireEventProxy: SessionExpirePreventActionHandler,
SessionTimeoutDelegateHandler {
}
