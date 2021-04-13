//
//  ChangeNetworkPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ChangeNetworkPresenter {
    weak var view: ChangeNetworkViewInput!
    weak var output: ChangeNetworkModuleOutput?
    
    var interactor: ChangeNetworkInteractorInput!
    var router: ChangeNetworkRouterInput!
}

// MARK: - ChangeNetworkModuleInput

extension ChangeNetworkPresenter: ChangeNetworkModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    fileprivate func updateView() {
        let models = interactor.getNetworks()
        view.setupInitialState(with: models)
    }
}

// MARK: - ChangeNetworkViewOutput

extension ChangeNetworkPresenter: ChangeNetworkViewOutput {
    func viewIsReady() {
        updateView()
    }
    
    func actionSelectNetwork(model: ChangeNetworkModel<BTCNetworkType>) {
        interactor.changeNetwork(network: model.value)
        updateView()
    }
    
    func actionBack() {
        router.dismiss(view: view)
    }
}

// MARK: - ChangeNetworkInteractorOutput

extension ChangeNetworkPresenter: ChangeNetworkInteractorOutput {
    func didGetNoWallets() {
        output?.didGetNoWallets()
    }
}
