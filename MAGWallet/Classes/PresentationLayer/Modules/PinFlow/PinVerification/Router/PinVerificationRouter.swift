//
//  PinVerificationPinVerificationRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class PinVerificationRouter: PinVerificationRouterInput {
    weak var view: UIViewController?
    
    func presentForgotPin(output: ForgotPinModuleOutput) {
        guard let view = view else {
            return
        }
        let module = ForgotPinModuleConfigurator().configureModule()
        module.output = output
        view.navigationController?.pushViewController(module.viewController, animated: true)
    }
}
