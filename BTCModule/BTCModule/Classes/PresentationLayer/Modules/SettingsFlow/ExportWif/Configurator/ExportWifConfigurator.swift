//
//  ExportBrainkeyExportBrainkeyConfigurator.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class ExportBrainkeyModuleConfigurator {
    func configureModule (assembler: ApplicationAssembler) -> ExportBrainkeyModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = assembler.moduleAssembly.resolver.resolve(ExportBrainkeyModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
