//
//  ExportBrainkeyProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ExportBrainkeyViewInput: class, Presentable {
    func setupInitialState(brainkey: String)
}

protocol ExportBrainkeyViewOutput {
    func viewIsReady()
    func actionBack()
    func actionCopy()
}

protocol ExportBrainkeyModuleInput: class {
    var viewController: UIViewController { get }
    var output: ExportBrainkeyModuleOutput? { get set }
    
    func presentBrainkey(brainkey: String,
                         from viewController: UIViewController)
}

protocol ExportBrainkeyModuleOutput: class {
}

protocol ExportBrainkeyInteractorInput {
    func presentSnackBar(_ snackBar: SnackBarPresentable)
}

protocol ExportBrainkeyInteractorOutput: class {
}

protocol ExportBrainkeyRouterInput {
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
}
