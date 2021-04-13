//
//  AutoblockAutoblockProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AutoblockViewInput: class, Presentable {
    func setupInitialState(models: [AutoblockModel])
}

protocol AutoblockViewOutput {
    func viewIsReady()
    func actionSelectAutoblockTime(model: AutoblockModel)
    func actionBack()
}

protocol AutoblockModuleInput: class {
	var viewController: UIViewController { get }
	var output: AutoblockModuleOutput? { get set }
    
    func presentAutoblock(from: UIViewController)
}

protocol AutoblockModuleOutput: class {
    func didSelectAutoblockTime()
}

protocol AutoblockInteractorInput {
    func getBlockTimes() -> [AutoblockModel]
    func saveCurrentAutoblockTime(time: BlockTime)
}

protocol AutoblockInteractorOutput: class {
}

protocol AutoblockRouterInput {
    func dismsiss(view: AutoblockViewInput)
}
