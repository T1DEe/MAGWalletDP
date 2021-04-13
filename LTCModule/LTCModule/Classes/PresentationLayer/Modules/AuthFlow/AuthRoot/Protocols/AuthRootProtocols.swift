//
//  AuthRootAuthRootProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AuthRootViewInput: class, Presentable {
    func setupInitialState()
}

protocol AuthRootViewOutput {
    func viewIsReady()
    func viewDismissed(isMovingFromParent: Bool)
}

protocol AuthRootModuleInput: SubflowModule {
	var viewController: UIViewController { get }
	var output: AuthRootModuleOutput? { get set }
    var needShowBack: Bool { get set }
}

protocol AuthRootModuleOutput: class {
    func completeAuthFlow()
    func cancelAuthFlow(autoCanceled: Bool)
}

protocol AuthRootInteractorInput {
    func bindToEvents()
}

protocol AuthRootInteractorOutput: class {
    func didAuthComplete()
}

protocol AuthRootRouterInput {
    func presentAuthFlowSelection(output: AuthFlowSelectionModuleOutput, needShowBack: Bool)
}
