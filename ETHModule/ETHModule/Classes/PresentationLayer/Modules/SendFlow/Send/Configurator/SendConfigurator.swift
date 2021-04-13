//
//  SendConfigurator.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class SendModuleConfigurator {
    func configureModule (assembler: ApplicationAssembler) -> SendModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = assembler.moduleAssembly.resolver.resolve(SendModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
