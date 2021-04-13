//
//  ForgotPinProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol ForgotPinViewInput: class, Presentable {
    func setupInitialState()
}

protocol ForgotPinViewOutput {
    func viewIsReady()
    
    func actionBack()
    func actionClear()
}

protocol ForgotPinModuleInput: class {
	var viewController: UIViewController { get }
	var output: ForgotPinModuleOutput? { get set }
}

protocol ForgotPinModuleOutput: class {
    func actionClear()
}

protocol ForgotPinInteractorInput {
}

protocol ForgotPinInteractorOutput: class {
}

protocol ForgotPinRouterInput {
}
