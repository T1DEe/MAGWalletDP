//
//  SensitiveDataEventProxyImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public final class SensitiveDataEventProxyImp: SensitiveDataEventProxy {
    public weak var delegate: SensitiveDataEventDelegate? {
        didSet {
            sensitiveDataDelegates.addObject(delegate)
        }
    }
    
    private var sensitiveDataDelegates = NSPointerArray.weakObjects()
    
    public init() {}

    public func processCommand(_ command: SecureDataCommand) {
        sensitiveDataDelegates.compact()
        
        for index in 0..<sensitiveDataDelegates.count {
            if let delegate = sensitiveDataDelegates.object(at: index) as? SensitiveDataEventDelegate {
                delegate.didProcessCommand(command)
            }
        }
    }
}
