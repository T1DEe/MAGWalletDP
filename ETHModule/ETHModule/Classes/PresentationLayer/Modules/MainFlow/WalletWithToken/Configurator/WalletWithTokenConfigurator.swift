//
//  WalletWithTokenWalletWithTokenConfigurator.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class WalletWithTokenModuleConfigurator {
    func configureModule (applicationAssembler: ApplicationAssembler) -> WalletModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = applicationAssembler.moduleAssembly.resolver.resolve(WalletModuleInput.self, name: "Token")!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
