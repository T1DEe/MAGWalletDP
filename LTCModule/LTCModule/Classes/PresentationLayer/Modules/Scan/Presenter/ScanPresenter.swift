//
//  ScanScanPresenter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ScanPresenter {
    weak var view: ScanViewInput!
    weak var output: ScanModuleOutput?
    
    var interactor: ScanInteractorInput!
    var router: ScanRouterInput!
    
    var isScaned = false
}

// MARK: - ScanModuleInput

extension ScanPresenter: ScanModuleInput {
      var viewController: UIViewController {
        return view.viewController
      }
}

// MARK: - ScanViewOutput

extension ScanPresenter: ScanViewOutput {
    func viewIsReady() {
    }
    
    func actionScan(string: String) {
        guard isScaned == false else {
            return
        }
        isScaned = true
        let entity = interactor.parceLTCScan(string: string)
        output?.didScanLtcQr(entity: entity)
        view.dissmiss()
    }
    
    func actionBack() {
        view.dissmiss()
    }
    
    func cameraPermissionsDenied() {
        let snackBar = router.getButtonSnackBar()
        let model = ButtonSnackBarModel(isBlocker: false,
                                        isError: false,
                                        title: R.string.localization.qrcodeScreenCameraDeniedTitle(),
                                        message: R.string.localization.qrcodeScreenCameraDeniedMessage(),
                                        leftButtonTitle: R.string.localization.errorOkButtonTitle(),
                                        rightButtonTitle: R.string.localization.qrcodeScreenCameraDeniedGoToSettingsButton())
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        interactor.presentSnackBar(snackBar)
        output?.permissionsDenied()
    }
}

extension ScanPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        router.openSettings()
    }
    
    func actionLeftButton(snackBar: ButtonSnackBarViewInput) {
        view.dissmiss()
    }
    
    func actionDismiss(snackBar: ButtonSnackBarViewInput) {
        view.dissmiss()
    }
}

// MARK: - ScanInteractorOutput

extension ScanPresenter: ScanInteractorOutput {
    func didFailScan() {
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: false,
                                           title: R.string.localization.qrcodeScanErrorTitle(),
                                           buttonTitle: R.string.localization.errorOkButtonTitle())
        snackBar.setButtonSnackBarModel(model)
        
        interactor.presentSnackBar(snackBar)
    }
}
