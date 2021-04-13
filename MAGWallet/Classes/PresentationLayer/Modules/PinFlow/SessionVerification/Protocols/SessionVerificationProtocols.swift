//
//  PinVerificationSessionVerificationProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol SessionVerificationViewInput: class, Presentable {
    func setupErrorState()
}

protocol SessionVerificationViewOutput {
    func viewIsReady()
    func actionBack()
    func actionEnterPin(_ pin: String)
    func actionForgotPin()
}

protocol SessionVerificationModuleInput: class {
    var viewController: UIViewController { get }
    var output: SessionVerificationModuleOutput? { get set }

    func presentPin(from: UIViewController)
}

protocol SessionVerificationModuleOutput: class {
    func actionDidSessionVerified()
    func actionDidCancelVerify()
    func actionLogout()
}

protocol SessionVerificationInteractorInput {
    func verifyPin(_ pin: String) -> Bool
    func getAvailableBiometry() -> BiometryType?
    func getPinFromTouchId()
}

protocol SessionVerificationInteractorOutput: class {
    func didGetPinFromBiometric(pin: String)
    func didFailGetPinFromBiometric(error: String)
}

protocol SessionVerificationRouterInput {
    func presentForgotPin(output: ForgotPinModuleOutput)
}
