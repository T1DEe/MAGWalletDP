//
//  AuthRootAuthRootPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum AuthRootDismissReason {
    case completed
    case canceledByButton
    case canceled
}

class AuthRootPresenter {
    weak var view: AuthRootViewInput!
    weak var output: AuthRootModuleOutput?
    var needShowBack: Bool = false
    
    var interactor: AuthRootInteractorInput!
    var router: AuthRootRouterInput!
    
    var dismissReason: AuthRootDismissReason = .canceled
}

// MARK: - AuthRootModuleInput

extension AuthRootPresenter: AuthRootModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - AuthRootViewOutput

extension AuthRootPresenter: AuthRootViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        router.presentAuthFlowSelection(output: self, needShowBack: needShowBack)
    }
    
    func viewDismissed(isMovingFromParent: Bool) {
        guard isMovingFromParent else {
            return
        }
        switch dismissReason {
        case .completed, .canceledByButton:
            return
            
        case .canceled:
            output?.cancelAuthFlow(autoCanceled: true)
        }
    }
}

extension AuthRootPresenter: AuthFlowSelectionModuleOutput {
    func actionBack() {
        dismissReason = .canceledByButton
        output?.cancelAuthFlow(autoCanceled: false)
    }
}

// MARK: - AuthRootInteractorOutput

extension AuthRootPresenter: AuthRootInteractorOutput {
    func didAuthComplete() {
        dismissReason = .completed
        output?.completeAuthFlow()
    }
}
