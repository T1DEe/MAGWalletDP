//
//  AuthFlowSelectionAuthFlowSelectionProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AuthFlowSelectionViewInput: class, Presentable {
    func setupInitialState(showBack: Bool)
}

protocol AuthFlowSelectionViewOutput {
    func viewIsReady()
    
    func actionImport()
    func actionCreateNew()
    func actionBack()
}

protocol AuthFlowSelectionModuleInput: class {
	var viewController: UIViewController { get }
	var output: AuthFlowSelectionModuleOutput? { get set }
    var needShowBack: Bool { get set }
}

protocol AuthFlowSelectionModuleOutput: class {
    func actionBack()
}

protocol AuthFlowSelectionInteractorInput {
}

protocol AuthFlowSelectionInteractorOutput: class {
}

protocol AuthFlowSelectionRouterInput {
//    func presentImport(output: AuthImportBrainkeyModuleOutput)
    func presentImport()
    func presentCreate()
}
