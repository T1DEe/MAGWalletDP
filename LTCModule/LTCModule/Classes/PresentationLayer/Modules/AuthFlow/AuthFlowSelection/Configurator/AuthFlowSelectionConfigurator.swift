//
//  AuthFlowSelectionAuthFlowSelectionConfigurator.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class AuthFlowSelectionModuleConfigurator {
    func configureModule (assembler: ApplicationAssembler) -> AuthFlowSelectionModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = assembler.moduleAssembly.resolver.resolve(AuthFlowSelectionModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
