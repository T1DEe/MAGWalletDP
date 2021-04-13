//
//  ExportBrainkeyPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ExportBrainkeyPresenter {
    weak var view: ExportBrainkeyViewInput!
    weak var output: ExportBrainkeyModuleOutput?
    
    var interactor: ExportBrainkeyInteractorInput!
    var router: ExportBrainkeyRouterInput!
    
    var brainkey: String!
}

// MARK: - ExportBrainkeyModuleInput

extension ExportBrainkeyPresenter: ExportBrainkeyModuleInput {
      var viewController: UIViewController {
        return view.viewController
      }
    
    func presentBrainkey(brainkey: String,
                         from viewController: UIViewController) {
        self.brainkey = brainkey
        view.present(fromViewController: viewController)
    }
}

// MARK: - ExportBrainkeyViewOutput

extension ExportBrainkeyPresenter: ExportBrainkeyViewOutput {
    func viewIsReady() {
        view.setupInitialState(brainkey: brainkey)
    }
    
    func actionBack() {
        view.dissmiss()
    }
    
    func actionCopy() {
        UIPasteboard.general.string = brainkey
        
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: false,
                                           title: R.string.localization.authCopyCopyMessage(),
                                           buttonTitle: R.string.localization.errorOkButtonTitle())
        snackBar.setButtonSnackBarModel(model)
        
        interactor.presentSnackBar(snackBar)
    }
}

// MARK: - ExportBrainkeyInteractorOutput

extension ExportBrainkeyPresenter: ExportBrainkeyInteractorOutput {
}
