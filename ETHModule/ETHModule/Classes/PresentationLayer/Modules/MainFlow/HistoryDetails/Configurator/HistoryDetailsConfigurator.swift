//
//  HistoryDetailsConfigurator.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject
import UIKit

class HistoryDetailsModuleConfigurator {
    func configureModule(applicationAssembler: ApplicationAssembler) -> HistoryDetailsModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = applicationAssembler.moduleAssembly.resolver.resolve(HistoryDetailsModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
