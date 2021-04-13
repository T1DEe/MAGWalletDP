//
//  ChangeNetworkPresenter.swift
//  MAGWallet
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
    var networks: [NetworkConfigurable] = []
}

// MARK: - ChangeNetworkModuleInput

extension ChangeNetworkPresenter: ChangeNetworkModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    fileprivate func updateView() {
        let screenModel = interactor.getScreenNetworks(from: networks)
        view.setupInitialState(with: screenModel)
    }
}

// MARK: - ChangeNetworkViewOutput

extension ChangeNetworkPresenter: ChangeNetworkViewOutput {    
    func viewIsReady() {
        updateView()
    }
    
    func actionSelectNetwork(network: NetworkConfigurable, identifiableNetwork: IdentifiableNetwork) {
        interactor.changeNetwork(network: network, identifiableNetwork: identifiableNetwork)
        updateView()
    }
    
    func actionBack() {
        router.dismiss(view: view)
    }
}

// MARK: - ChangeNetworkInteractorOutput

extension ChangeNetworkPresenter: ChangeNetworkInteractorOutput {
}
