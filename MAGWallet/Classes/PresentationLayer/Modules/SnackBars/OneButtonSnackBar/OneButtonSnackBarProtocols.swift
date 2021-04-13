//
//  OneButtonSnackBarOneButtonSnackBarProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol OneButtonSnackBarViewInput: class, Presentable {
    func setupInitialState(model: OneButtonSnackBarModel)
}

protocol OneButtonSnackBarViewOutput {
    func viewIsReady()
    func actionButtonClick()
}

protocol OneButtonSnackBarModuleInput: SnackBarPresentable {
	var viewController: UIViewController { get }
	var output: OneButtonSnackBarModuleOutput? { get set }
    
    func setButtonSnackBarModel(_ model: OneButtonSnackBarModel)
}

protocol OneButtonSnackBarModuleOutput: class {
    func actionButton(snackBar: OneButtonSnackBarViewInput)
    func actionDismiss(snackBar: OneButtonSnackBarViewInput)
}

extension OneButtonSnackBarModuleOutput {
    func actionButton(snackBar: OneButtonSnackBarViewInput) {}
    func actionDismiss(snackBar: OneButtonSnackBarViewInput) {}
}

protocol OneButtonSnackBarInteractorInput {
}

protocol OneButtonSnackBarInteractorOutput: class {
}

protocol OneButtonSnackBarRouterInput {
}
