//
//  OneButtonSnackBarOneButtonSnackBarPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class OneButtonSnackBarPresenter {
    weak var view: OneButtonSnackBarViewInput!
    weak var output: OneButtonSnackBarModuleOutput?
    weak var dismissDelegate: SnackBarPresentableDelegate?
    
    var interactor: OneButtonSnackBarInteractorInput!
    var router: OneButtonSnackBarRouterInput!
    var buttonSnackBarModel: OneButtonSnackBarModel?
    
    var isFullScreen: Bool = false
    var needAddSwipeForClose: Bool = true
}

// MARK: - OneButtonSnackBarModuleInput

extension OneButtonSnackBarPresenter: OneButtonSnackBarModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    var snackBarView: UIView {
        if let viewController = viewController as? ButtonSnackBarViewController {
            _ = viewController.view
            return viewController.containerView
        }
        return viewController.view
    }
    
    var snackBarViewController: UIViewController {
        return viewController
    }
    
    func setButtonSnackBarModel(_ model: OneButtonSnackBarModel) {
        isFullScreen = model.isBlocker
        buttonSnackBarModel = model
    }
    
    func didDismiss() {
        output?.actionDismiss(snackBar: view)
    }
}

// MARK: - OneButtonSnackBarViewOutput

extension OneButtonSnackBarPresenter: OneButtonSnackBarViewOutput {
    func viewIsReady() {
        if let model = buttonSnackBarModel {
            view.setupInitialState(model: model)
        }
    }
    
    func actionButtonClick() {
        if let output = output {
            output.actionButton(snackBar: view)
        }
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
    
    func actionClose() {
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
}

// MARK: - OneButtonSnackBarInteractorOutput

extension OneButtonSnackBarPresenter: OneButtonSnackBarInteractorOutput {
}
