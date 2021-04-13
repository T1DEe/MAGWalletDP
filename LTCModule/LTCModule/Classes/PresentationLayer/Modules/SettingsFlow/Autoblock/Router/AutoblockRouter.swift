//
//  AutoblockAutoblockRouter.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AutoblockRouter: AutoblockRouterInput {
    weak var view: UIViewController?
    
    func dismiss(view: AutoblockViewInput) {
        view.dissmiss()
    }
}
