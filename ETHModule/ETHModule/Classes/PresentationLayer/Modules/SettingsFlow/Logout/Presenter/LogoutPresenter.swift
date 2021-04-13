//
//  LogoutLogoutPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class LogoutPresenter {
    weak var view: LogoutViewInput!
    weak var output: LogoutModuleOutput?
    
    var interactor: LogoutInteractorInput!
    var router: LogoutRouterInput!
}

// MARK: - LogoutModuleInput

extension LogoutPresenter: LogoutModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func actionCancel() {
        view.dissmiss()
    }
    
    func actionConfirm() {
        interactor.clearServices()
        interactor.unsubscribe()
        output?.didLogoutAction()
    }
}

// MARK: - LogoutViewOutput

extension LogoutPresenter: LogoutViewOutput {
    func viewIsReady() {
    }
}

// MARK: - LogoutInteractorOutput

extension LogoutPresenter: LogoutInteractorOutput {
}
