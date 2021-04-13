//
//  ChangeNetworkProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ChangeNetworkViewInput: class, Presentable {
    func setupInitialState(with models: [ChangeNetworkModel<ETHNetworkType>])
}

protocol ChangeNetworkViewOutput {
    func viewIsReady()
    func actionBack()
    func actionSelectNetwork(model: ChangeNetworkModel<ETHNetworkType>)
}

protocol ChangeNetworkModuleInput: SubflowModule {
	var viewController: UIViewController { get }
	var output: ChangeNetworkModuleOutput? { get set }
}

protocol ChangeNetworkModuleOutput: class {
    func didGetNoWallets()
}

protocol ChangeNetworkInteractorInput {
    func getNetworks() -> [ChangeNetworkModel<ETHNetworkType>]
    func changeNetwork(network: ETHNetworkType)
}

protocol ChangeNetworkInteractorOutput: class {
    func didGetNoWallets()
}

protocol ChangeNetworkRouterInput {
    func dismiss(view: ChangeNetworkViewInput)
}
