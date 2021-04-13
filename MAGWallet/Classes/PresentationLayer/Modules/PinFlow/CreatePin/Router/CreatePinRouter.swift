//
//  CreatePinCreatePinRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class CreatePinRouter: CreatePinRouterInput {
    weak var view: UIViewController?

    func dismiss(view: CreatePinViewInput) {
        view.dissmiss()
    }
}
