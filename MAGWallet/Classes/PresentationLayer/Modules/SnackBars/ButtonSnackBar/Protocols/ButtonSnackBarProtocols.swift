//
//  ButtonSnackBarButtonSnackBarProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ButtonSnackBarViewInput: class, Presentable {
    func setupInitialState(model: ButtonSnackBarModel)
}

protocol ButtonSnackBarViewOutput {
    func viewIsReady()
    func actionRightButton()
    func actionLeftButton()
    func actionCenterButton()
    func actionClose()
}

protocol ButtonSnackBarModuleInput: SnackBarPresentable {
    var viewController: UIViewController { get }
    var output: ButtonSnackBarModuleOutput? { get set }

    func setButtonSnackBarModel(_ model: ButtonSnackBarModel)
}

protocol ButtonSnackBarModuleOutput: class {
    func actionRightButton(snackBar: ButtonSnackBarViewInput)
    func actionLeftButton(snackBar: ButtonSnackBarViewInput)
    func actionCenterButton(snackBar: ButtonSnackBarViewInput)
    func actionDismiss(snackBar: ButtonSnackBarViewInput)
}

extension ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {}
    func actionLeftButton(snackBar: ButtonSnackBarViewInput) {}
    func actionCenterButton(snackBar: ButtonSnackBarViewInput) {}
    func actionDismiss(snackBar: ButtonSnackBarViewInput) {}
}

protocol ButtonSnackBarInteractorInput {
}

protocol ButtonSnackBarInteractorOutput: class {
}

protocol ButtonSnackBarRouterInput {
}
