//
//  SnackBarRootSnackBarRootPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import AudioToolbox
import SharedFilesModule
import UIKit

class SnackBarRootPresenter {
    weak var view: SnackBarRootViewInput!
    weak var output: SnackBarRootModuleOutput?
    
    var interactor: SnackBarRootInteractorInput!
    var router: SnackBarRootRouterInput!
    
    var currentSnackBar: SnackBarRootModel?
    var snackBarsQueueModels = [SnackBarRootModel]()
}

// MARK: - SnackBarRootModuleInput

extension SnackBarRootPresenter: SnackBarRootModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func presentSnackBar(snackBar: SnackBarPresentable, animated: Bool) {
        snackBar.dismissDelegate = self
        let snackBarRootModel = SnackBarRootModel(snackBarPresentableModel: snackBar,
                                                  snackBarViewController: snackBar.snackBarViewController,
                                                  snackBarView: snackBar.snackBarView,
                                                  shouldShowAnimated: true)
        
        if let currentSnackBar = currentSnackBar {
            snackBarsQueueModels.append(snackBarRootModel)
            interactor.stopTimer()
            view.removeSnackBarView(snackBar: currentSnackBar)
        } else {
            currentSnackBar = snackBarRootModel
            showNextSnackBar()
        }
    }
    
    func removeSnackBar(snackBar: SnackBarPresentable) {
        interactor.stopTimer()
        if let currentSnackBar = currentSnackBar {
            view.removeSnackBarView(snackBar: currentSnackBar)
        }
    }

    func actionOnEmptyPlaceTap() {
        guard let currentSnackBar = currentSnackBar else {
            return
        }
        if currentSnackBar.snackBarPresentableModel.isFullScreen == true {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

extension SnackBarRootPresenter: SnackBarPresentableDelegate {
    func dismissSnackBar(snackBar: SnackBarPresentable) {
        removeSnackBar(snackBar: snackBar)
    }
}

// MARK: - SnackBarRootViewOutput

extension SnackBarRootPresenter: SnackBarRootViewOutput {
    func viewIsReady() {
        showNextSnackBar()
    }

    func didRemoveSnackBarView() {
        currentSnackBar?.snackBarPresentableModel.didDismiss()
        currentSnackBar = nil
        
        if let snackBar = snackBarsQueueModels.last {
            self.currentSnackBar = snackBar
            snackBarsQueueModels.removeAll()
            showNextSnackBar()
        }
    }
    
    fileprivate func showNextSnackBar() {
        guard let currentSnackBar = currentSnackBar else {
            return
        }
        view.setupInitialState(snackBar: currentSnackBar)
        if currentSnackBar.snackBarPresentableModel.isFullScreen == false {
            interactor.startTimer()
        } else {
            interactor.stopTimer()
        }
    }
    
    func actionSwipeDown() {
        if let currentSnackBar = currentSnackBar {
            view.removeSnackBarView(snackBar: currentSnackBar)
        }
    }
}

// MARK: - SnackBarRootInteractorOutput

extension SnackBarRootPresenter: SnackBarRootInteractorOutput {
    func hideSnackBar() {
        if let currentSnackBar = currentSnackBar {
            removeSnackBar(snackBar: currentSnackBar.snackBarPresentableModel)
        }
    }
}
