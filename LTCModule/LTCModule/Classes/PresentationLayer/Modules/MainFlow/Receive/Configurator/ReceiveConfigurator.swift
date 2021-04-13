//
//  ReceiveReceiveConfigurator.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ReceiveModuleConfigurator {
    func configureModule (assembler: ApplicationAssembler) -> ReceiveModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = assembler.moduleAssembly.resolver.resolve(ReceiveModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
