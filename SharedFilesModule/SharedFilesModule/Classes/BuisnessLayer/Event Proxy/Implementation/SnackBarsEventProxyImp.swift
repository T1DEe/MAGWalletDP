//
//  SnackBarsEventProxyImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public final class SnackBarsEventProxyImp: SnackBarsEventProxy {
    public weak var delegate: SnackBarsEventDelegate? {
        didSet {
            snackBarsDelegates.addObject(delegate)
        }
    }
    
    private var snackBarsDelegates = NSPointerArray.weakObjects()
    
    public init() {}
    
    public func actionPresentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsDelegates.compact()
        
        for index in 0..<snackBarsDelegates.count {
            if let delegate = snackBarsDelegates.object(at: index) as? SnackBarsEventDelegate {
                delegate.didPresentSnackBar(snackBar)
            }
        }
    }
}
