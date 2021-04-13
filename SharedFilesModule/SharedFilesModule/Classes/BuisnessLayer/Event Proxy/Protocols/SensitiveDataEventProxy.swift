//
//  SensitiveDataEventProxy.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol SensitiveDataEventDelegate: class {
    func didProcessCommand(_ command: SecureDataCommand)
}

public protocol SensitiveDataEventDelegateHandler: class {
    var delegate: SensitiveDataEventDelegate? { get set }
}

public protocol SensitiveDataEventActionHandler {
    func processCommand(_ command: SecureDataCommand)
}

public protocol SensitiveDataEventProxy: SensitiveDataEventActionHandler, SensitiveDataEventDelegateHandler {
}
