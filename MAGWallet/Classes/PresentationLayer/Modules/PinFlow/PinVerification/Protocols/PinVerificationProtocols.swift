//
//  PinVerificationPinVerificationProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol PinVerificationViewInput: class, Presentable {
    func setupErrorState()
}

protocol PinVerificationViewOutput {
    func viewIsReady()
    func actionBack()
    func actionEnterPin(_ pin: String)
    func actionForgotPin()
}

protocol PinVerificationModuleInput: class {
    var viewController: UIViewController { get }
    var output: PinVerificationModuleOutput? { get set }

    func presentPin(from: UIViewController)
}

protocol PinVerificationModuleOutput: class {
    func actionDidVerifyPin()
    func actionCancelVerify()
    func actionLogout()
}

protocol PinVerificationInteractorInput {
    func verifyPin(_ pin: String) -> Bool
    func getAvailableBiometry() -> BiometryType?
    func getPinFromTouchId()
}

protocol PinVerificationInteractorOutput: class {
    func didGetPinFromBiometric(pin: String)
    func didFailGetPinFromBiometric(error: String)
}

protocol PinVerificationRouterInput {
    func presentForgotPin(output: ForgotPinModuleOutput)
}
