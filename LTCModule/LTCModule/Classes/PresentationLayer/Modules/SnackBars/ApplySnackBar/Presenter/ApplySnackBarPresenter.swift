//
//  ApplySnackBarApplySnackBarPresenter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ApplySnackBarPresenter {
    weak var view: ApplySnackBarViewInput!
    weak var output: ApplySnackBarModuleOutput?
    weak var dismissDelegate: SnackBarPresentableDelegate?
    
    var interactor: ApplySnackBarInteractorInput!
    var router: ApplySnackBarRouterInput!
    
    var isFullScreen: Bool = false
    var needAddSwipeForClose: Bool = false
    
    var model: ApplySnackBarModel!
}

// MARK: - ApplySnackBarModuleInput

extension ApplySnackBarPresenter: ApplySnackBarModuleInput {
    var snackBarView: UIView {
        if let viewController = viewController as? ApplySnackBarViewController {
            _ = viewController.view
            return viewController.containerView
        }
        return viewController.view
    }
    
    var snackBarViewController: UIViewController {
        return viewController
    }
    
    var viewController: UIViewController {
        return view.viewController
    }
    
    func didDismiss() { }
}

// MARK: - ApplySnackBarViewOutput

extension ApplySnackBarPresenter: ApplySnackBarViewOutput {
    func viewIsReady() {
        view.setupInitialState(model: model)
    }
    
    func actionApply() {
        output?.actionApply(snackBar: self, model: model)
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
    
    func acitonDeny() {
        output?.actionDenySendData(snackBar: self)
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
}

// MARK: - ApplySnackBarInteractorOutput

extension ApplySnackBarPresenter: ApplySnackBarInteractorOutput {
}
