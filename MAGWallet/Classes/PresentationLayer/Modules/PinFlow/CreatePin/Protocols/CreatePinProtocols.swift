//
//  CreatePinCreatePinProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol CreatePinViewInput: class, Presentable {
    func setupInitialState()
    func setupErrorState()
}

protocol CreatePinViewOutput {
    func viewIsReady()
    func actionBack()
    func actionEnterPin(_ pin: String, _ repeatedPin: String)
}

protocol CreatePinModuleInput: class {
    var viewController: UIViewController { get }
    var output: CreatePinModuleOutput? { get set }

    func presentCreatePin(from: UIViewController)
}

protocol CreatePinModuleOutput: class {
    func didCreatePin()
}

protocol CreatePinInteractorInput {
    func checkPins(firstPin: String, secongPin: String) -> Bool
    func storePin(pin: String)
}

protocol CreatePinInteractorOutput: class {
    func didStorePin()
    func didFailStorePin()
}

protocol CreatePinRouterInput {
    func dismiss(view: CreatePinViewInput)
}
