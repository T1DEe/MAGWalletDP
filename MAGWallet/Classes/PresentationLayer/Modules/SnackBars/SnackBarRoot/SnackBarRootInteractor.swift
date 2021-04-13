//
//  SnackBarRootSnackBarRootInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

class SnackBarRootInteractor {
    weak var output: SnackBarRootInteractorOutput!
    
    var workItem: DispatchWorkItem?
}

// MARK: - SnackBarRootInteractorInput

extension SnackBarRootInteractor: SnackBarRootInteractorInput {
    func startTimer() {
        workItem?.cancel()
        let hideSnackBarWorkItem = DispatchWorkItem { [weak self] in
            guard let workItem = self?.workItem else {
                return
            }
            
            self?.output.hideSnackBar()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0,
                                          execute: workItem)
        }
        
        workItem = hideSnackBarWorkItem
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0,
                                      execute: hideSnackBarWorkItem)
    }
    
    func stopTimer() {
        workItem?.cancel()
        workItem = nil
    }
}
