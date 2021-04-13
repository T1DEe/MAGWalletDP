//
//  MainMainPresenter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class MainPresenter {
    weak var view: MainViewInput!
    weak var output: MainModuleOutput?
    
    var interactor: MainInteractorInput!
    var router: MainRouterInput!
    var needShowBack: Bool = false
    
    var history: HistoryModuleInput!
    var wallet: WalletModuleInput!
    
    weak var navController: UIViewController?
    
    func getViewController() -> UIViewController {
        if let navController = navController {
            return navController
        } else {
            let controller = view.viewController.wrapToNavigationController(BaseNavigationController())
            navController = controller
            return controller
        }
    }
}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {
  	var viewController: UIViewController {
    	return getViewController()
  	}
}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {
    func viewIsReady() {
        let roots = router.obtainRoots(walletOutput: self, historyOutput: self)
        wallet = router.obtainWalletModule(output: self)
        wallet.needShowBack = needShowBack
        history = router.obtainHistoryModule(output: self)
        view.setupInitialState(root: roots)
    }
    
    func actionSend() {
        output?.didSelectSend()
    }
    
    func actionReceive() {
        router.presentReceive()
    }
    
    func topContainerHeightChanged(height: CGFloat) {
        wallet.heightDidChanged(height: height)
        history.offsetDidChange(offset: height)
    }
}

extension MainPresenter: HistoryModuleOutput {
    func scrollViewDidEndDeselerating() {
        view.setupAutoScroll()
    }
    
    func scrollTopOffsetDidChange(offset: CGFloat) {
        view.setupScrollOffset(offset: offset)
    }
    
    func didSelectExplorer(url: URL) {
        output?.didSelectExplorer(url: url)
    }
}

extension MainPresenter: WalletModuleOutput {
    func didSelectSettings() {
        output?.didSelectSettings()
    }
    
    func didSelectQRCode() {
        router.presentScan(output: self)
    }
    
    func didSelectBack() {
        output?.didSelectBack()
    }
}

extension MainPresenter: ScanModuleOutput {
    func didScanLtcQr(entity: ScanEntity) {
        output?.didScan(scanEntity: entity)
    }
    
    func permissionsDenied() { }
}

// MARK: - MainInteractorOutput

extension MainPresenter: MainInteractorOutput {
}
