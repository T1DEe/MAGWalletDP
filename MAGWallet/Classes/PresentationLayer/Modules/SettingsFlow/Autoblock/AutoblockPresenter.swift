//
//  AutoblockAutoblockPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class AutoblockPresenter {
    weak var view: AutoblockViewInput!
    weak var output: AutoblockModuleOutput?
    
    var interactor: AutoblockInteractorInput!
    var router: AutoblockRouterInput!
}

// MARK: - AutoblockModuleInput

extension AutoblockPresenter: AutoblockModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}

    func presentAutoblock(from: UIViewController) {
        view.present(fromViewController: from)
    }
    
    fileprivate func updateView() {
        let models = interactor.getBlockTimes()
        view.setupInitialState(models: models)
    }
}

// MARK: - AutoblockViewOutput

extension AutoblockPresenter: AutoblockViewOutput {
    func viewIsReady() {
        updateView()
    }
    
    func actionSelectAutoblockTime(model: AutoblockModel) {
        interactor.saveCurrentAutoblockTime(time: model.time)
        output?.didSelectAutoblockTime()
        updateView()
    }
    
    func actionBack() {
        router.dismsiss(view: view)
    }
}

// MARK: - AutoblockInteractorOutput

extension AutoblockPresenter: AutoblockInteractorOutput {
}
