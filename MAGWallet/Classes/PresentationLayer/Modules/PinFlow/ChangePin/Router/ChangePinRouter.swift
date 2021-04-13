//
//  ChangePinChangePinRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ChangePinRouter: ChangePinRouterInput {
    weak var view: UIViewController?
    weak var blockScreen: UIViewController?

    func dismiss(view: ChangePinViewInput) {
        view.viewController.dismiss(animated: true, completion: nil)
    }
}
