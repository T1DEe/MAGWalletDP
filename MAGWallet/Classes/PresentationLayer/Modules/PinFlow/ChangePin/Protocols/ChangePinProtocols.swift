//
//  ChangePinChangePinProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol ChangePinViewInput: class, Presentable {
    func setupInitialState()
    func setupNewStep()
    func setupRepeateNewStep()
    func setupFailedStateAndOld()
}

protocol ChangePinViewOutput {
    func viewIsReady()

    func actionBack()
    func actionEnterPin(_ pin: String)
}

protocol ChangePinModuleInput: class {
    var viewController: UIViewController { get }
    var output: ChangePinModuleOutput? { get set }

    func presentChangePin(from: UIViewController)
}

protocol ChangePinModuleOutput: class {
    func didChangePin()
    func didCancelChangePin()
}

protocol ChangePinInteractorInput {
    func validatePin(_ pin: String) -> Bool
    func changePin(newPin: String, oldPin: String)
}

protocol ChangePinInteractorOutput: class {
    func needDismiss()
    func didChangePin()
    func didFailChangePin()
}

protocol ChangePinRouterInput {
    func dismiss(view: ChangePinViewInput)
}
