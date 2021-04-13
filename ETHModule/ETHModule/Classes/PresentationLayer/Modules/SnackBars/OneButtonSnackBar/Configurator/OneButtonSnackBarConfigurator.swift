//
//  OneButtonSnackBarOneButtonSnackBarConfigurator.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class OneButtonSnackBarModuleConfigurator {
    func configureModule (applicationAssembler: ApplicationAssembler) -> OneButtonSnackBarModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = applicationAssembler.moduleAssembly.resolver.resolve(OneButtonSnackBarModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
