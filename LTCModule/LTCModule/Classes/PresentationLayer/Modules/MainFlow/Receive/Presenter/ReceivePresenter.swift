//
//  ReceiveReceivePresenter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ReceivePresenter {
    weak var view: ReceiveViewInput!
    weak var output: ReceiveModuleOutput?
    
    var interactor: ReceiveInteractorInput!
    var router: ReceiveRouterInput!
}

// MARK: - ReceiveModuleInput

extension ReceivePresenter: ReceiveModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - ReceiveViewOutput

extension ReceivePresenter: ReceiveViewOutput {
    func actionBack() {
        view.dissmiss()
    }
    
    func actionCopy(text: String) {
        UIPasteboard.general.string = text
        
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: false,
                                           title: R.string.localization.authCopyCopyMessage(),
                                           buttonTitle: R.string.localization.errorOkButtonTitle())
        snackBar.setButtonSnackBarModel(model)

        interactor.presentSnackBar(snackBar)
    }
    
    func viewIsReady() {
        let entity = interactor.obtainScreenEntity()
        view.setupState(entity: entity)
        
        let size = view.getqrCodeImageViewSize()
        interactor.obtainQRCode(size: size, entity: entity)
    }
}

// MARK: - ReceiveInteractorOutput

extension ReceivePresenter: ReceiveInteractorOutput {
    func didObtainQrcode(image: UIImage) {
        view.setupQRCodeImage(image: image)
    }
}
