//
//  AccountsAccountsConfigurator.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class AccountsModuleConfigurator {
    func configureModule (assembler: ApplicationAssembler) -> AccountsModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = assembler.moduleAssembly.resolver.resolve(AccountsModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
