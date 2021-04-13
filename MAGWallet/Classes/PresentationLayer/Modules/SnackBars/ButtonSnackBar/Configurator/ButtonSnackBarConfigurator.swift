//
//  ButtonSnackBarButtonSnackBarConfigurator.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ButtonSnackBarModuleConfigurator {
    func configureModule() -> ButtonSnackBarModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(ButtonSnackBarModuleInput.self)!
        // swiftlint:enable force_unwrapping

        return moduleInput
    }
}
