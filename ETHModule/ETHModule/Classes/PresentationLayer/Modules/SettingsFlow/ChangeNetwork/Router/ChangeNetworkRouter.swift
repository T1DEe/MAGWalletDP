//
//  ChangeNetworkRouter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ChangeNetworkRouter {
	weak var view: UIViewController?
}

// MARK: - ChangeNetworkRouterInput

extension ChangeNetworkRouter: ChangeNetworkRouterInput {
    func dismiss(view: ChangeNetworkViewInput) {
        view.dissmiss()
    }
}
