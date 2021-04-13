//
//  SplashSplashProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol SplashViewInput: class, Presentable {
    func setupInitialState()
}

protocol SplashViewOutput {
    func viewIsReady()
}

protocol SplashModuleInput: class {
    var viewController: UIViewController { get }
    var output: SplashModuleOutput? { get set }
}

protocol SplashModuleOutput: class {
}

protocol SplashInteractorInput {
}

protocol SplashInteractorOutput: class {
}

protocol SplashRouterInput {
}
