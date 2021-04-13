//
//  RootRootProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol RootViewInput: class, Presentable {
    func setupInitialState()
}

protocol RootViewOutput {
    func viewIsReady()
}

protocol RootModuleInput: class {
    var viewController: UIViewController { get }
    var output: RootModuleOutput? { get set }
}

protocol RootModuleOutput: class {
    func viewIsReady()
}

protocol RootInteractorInput {
    func bindToEvents()
    func startCountingSplash()
    func isAuthorized() -> Bool
    func makeLogout()
}

protocol RootInteractorOutput: class {
    func didAuth()
    func didLogout()
    func shoudShowAuth()
}

protocol RootRouterInput {
    func presentPinVerification(output: PinVerificationModuleOutput)
    func presentMain(output: MainRoutingModuleOutput)
    func presentCreatePin(output: CreatePinModuleOutput)
    func presentChangePin(output: ChangePinModuleOutput)
    func presentSplash()
}
