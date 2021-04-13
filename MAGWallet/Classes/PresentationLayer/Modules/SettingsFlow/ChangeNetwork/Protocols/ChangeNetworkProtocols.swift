//
//  ChangeNetworkProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ChangeNetworkViewInput: class, Presentable {
    func setupInitialState(with model: ChangeNetworkScreenModel)
}

protocol ChangeNetworkViewOutput {
    func viewIsReady()
    func actionBack()
    func actionSelectNetwork(network: NetworkConfigurable, identifiableNetwork: IdentifiableNetwork)
}

protocol ChangeNetworkModuleInput: SubflowModule {
	var viewController: UIViewController { get }
	var output: ChangeNetworkModuleOutput? { get set }
    var networks: [NetworkConfigurable] { get set }
}

protocol ChangeNetworkModuleOutput: class {
}

protocol ChangeNetworkInteractorInput {
    func getScreenNetworks(from networks: [NetworkConfigurable]) -> ChangeNetworkScreenModel
    func changeNetwork(network: NetworkConfigurable, identifiableNetwork: IdentifiableNetwork)
}

protocol ChangeNetworkInteractorOutput: class {
}

protocol ChangeNetworkRouterInput {
    func dismiss(view: ChangeNetworkViewInput)
}
