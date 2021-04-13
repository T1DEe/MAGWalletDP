//
//  PinVerificationUnlockPinProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol UnlockPinViewInput: class, Presentable {
    func setupErrorState()
}

protocol UnlockPinViewOutput {
    func viewIsReady()
    func actionBack()
    func actionEnterPin(_ pin: String)
}

protocol UnlockPinModuleInput: class {
    var viewController: UIViewController { get }
    var output: UnlockPinModuleOutput? { get set }

    func presentPin(from: UIViewController)
}

protocol UnlockPinModuleOutput: class {
    func actionDidVerifyPin(pin: String)
    func actionCancelVerify()
}

protocol UnlockPinInteractorInput {
    func verifyPin(_ pin: String) -> Bool
    func getAvailableBiometry() -> BiometryType?
    func getPinFromTouchId()
}

protocol UnlockPinInteractorOutput: class {
    func didGetPinFromBiometric(pin: String)
    func didFailGetPinFromBiometric(error: String)
}

protocol UnlockPinRouterInput {
}
