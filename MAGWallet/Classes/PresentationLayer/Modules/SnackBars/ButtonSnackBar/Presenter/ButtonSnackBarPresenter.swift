//
//  ButtonSnackBarButtonSnackBarPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ButtonSnackBarPresenter {
    weak var view: ButtonSnackBarViewInput!
    weak var output: ButtonSnackBarModuleOutput?
    weak var dismissDelegate: SnackBarPresentableDelegate?

    var interactor: ButtonSnackBarInteractorInput!
    var router: ButtonSnackBarRouterInput!
    var buttonSnackBarModel: ButtonSnackBarModel?

    var isFullScreen: Bool = false
    var needAddSwipeForClose: Bool = true
}

// MARK: - ButtonSnackBarModuleInput

extension ButtonSnackBarPresenter: ButtonSnackBarModuleInput {
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

      var viewController: UIViewController {
        return view.viewController
    }

    func setButtonSnackBarModel(_ model: ButtonSnackBarModel) {
        isFullScreen = model.isBlocker
        buttonSnackBarModel = model
    }

    func didDismiss() {
        output?.actionDismiss(snackBar: view)
    }
}

// MARK: - ButtonSnackBarViewOutput

extension ButtonSnackBarPresenter: ButtonSnackBarViewOutput {
    func viewIsReady() {
        if let model = buttonSnackBarModel {
            view.setupInitialState(model: model)
        }
    }

    func actionRightButton() {
        if let output = output {
            output.actionRightButton(snackBar: view)
        }
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }

    func actionLeftButton() {
        if let output = output {
            output.actionLeftButton(snackBar: view)
        }
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }

    func actionCenterButton() {
        if let output = output {
            output.actionCenterButton(snackBar: view)
        }
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }

    func actionClose() {
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
}

// MARK: - ButtonSnackBarInteractorOutput

extension ButtonSnackBarPresenter: ButtonSnackBarInteractorOutput {
}
