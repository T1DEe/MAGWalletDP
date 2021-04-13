//
//  ForgotPinPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ForgotPinPresenter {
    weak var view: ForgotPinViewInput!
    weak var output: ForgotPinModuleOutput?
    
    var interactor: ForgotPinInteractorInput!
    var router: ForgotPinRouterInput!
}

// MARK: - ForgotPinModuleInput

extension ForgotPinPresenter: ForgotPinModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - ForgotPinViewOutput

extension ForgotPinPresenter: ForgotPinViewOutput {
    func viewIsReady() {
    }
    
    func actionBack() {
        view.dissmiss()
    }
    
    func actionClear() {
        output?.actionClear()
    }
}

// MARK: - ForgotPinInteractorOutput

extension ForgotPinPresenter: ForgotPinInteractorOutput {
}
