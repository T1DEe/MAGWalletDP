//
//  ETHUpdateEventProxyImp.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

final class ETHUpdateEventProxyImp: ETHUpdateEventProxy {
    weak var delegate: ETHUpdateEventDelegate? {
        didSet {
            delegates.addObject(delegate)
        }
    }
    
    fileprivate var delegates = NSPointerArray.weakObjects()
    
    func actionUpdateBalance() {
        delegates.compact()
        
        for index in 0..<delegates.count {
            if let delegate = delegates.object(at: index) as? ETHUpdateEventDelegate {
                delegate.didUpdateBalance()
            }
        }
    }
}
