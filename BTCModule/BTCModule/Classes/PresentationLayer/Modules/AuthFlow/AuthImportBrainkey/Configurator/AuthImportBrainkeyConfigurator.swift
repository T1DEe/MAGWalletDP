//
//  AuthImportBrainkeyAuthImportBrainkeyConfigurator.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class AuthImportBrainkeyModuleConfigurator {
    func configureModule (assembler: ApplicationAssembler) -> AuthImportBrainkeyModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = assembler.moduleAssembly.resolver.resolve(AuthImportBrainkeyModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
