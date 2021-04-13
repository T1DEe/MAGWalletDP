//
//  ApplicationModuleModuleConfigurator.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

public class ApplicationModuleModuleConfigurator {
    public init() {}

    public func configureModule () -> ApplicationModuleModuleInput {
        let applicationAssembler = ApplicationAssembler.rootAssembler()
        // swiftlint:disable force_unwrapping
        let moduleInput = applicationAssembler.moduleAssembly.resolver.resolve(ApplicationModuleModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
