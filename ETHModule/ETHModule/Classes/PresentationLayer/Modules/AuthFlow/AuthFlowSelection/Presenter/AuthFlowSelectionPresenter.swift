//
//  AuthFlowSelectionAuthFlowSelectionPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AuthFlowSelectionPresenter {
    weak var view: AuthFlowSelectionViewInput!
    weak var output: AuthFlowSelectionModuleOutput?
    var needShowBack: Bool = false
    
    var interactor: AuthFlowSelectionInteractorInput!
    var router: AuthFlowSelectionRouterInput!
}

// MARK: - AuthFlowSelectionModuleInput

extension AuthFlowSelectionPresenter: AuthFlowSelectionModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - AuthFlowSelectionViewOutput

extension AuthFlowSelectionPresenter: AuthFlowSelectionViewOutput {
    func viewIsReady() {
        view.setupInitialState(showBack: needShowBack)
    }
    
    func actionImport() {
        router.presentImport(output: self)
    }
    
    func actionCreateNew() {
        router.presentCreate()
    }
    
    func actionBack() {
        output?.actionBack()
    }
}

extension AuthFlowSelectionPresenter: AuthImportBrainkeyModuleOutput {
}

// MARK: - AuthFlowSelectionInteractorOutput

extension AuthFlowSelectionPresenter: AuthFlowSelectionInteractorOutput {
}
