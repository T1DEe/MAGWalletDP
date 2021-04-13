//
//  ApplySnackBarApplySnackBarProtocols.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ApplySnackBarViewInput: class, Presentable {
    func setupInitialState(model: ApplySnackBarModel)
}

protocol ApplySnackBarViewOutput {
    func viewIsReady()
    func actionApply()
    func acitonDeny()
}

protocol ApplySnackBarModuleInput: SnackBarPresentable {
    var viewController: UIViewController { get }
    var output: ApplySnackBarModuleOutput? { get set }
    
    func setSendData(currency: Currency, amount: String?, account: String)
}

protocol ApplySnackBarModuleOutput: class {
    func actionApply(snackBar: SnackBarPresentable, model: ApplySnackBarModel)
    func actionDenySendData(snackBar: SnackBarPresentable)
}

protocol ApplySnackBarInteractorInput {
}

protocol ApplySnackBarInteractorOutput: class {
}

protocol ApplySnackBarRouterInput {
}
