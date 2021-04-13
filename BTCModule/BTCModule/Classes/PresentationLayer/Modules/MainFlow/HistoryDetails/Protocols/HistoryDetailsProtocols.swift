//
//  HistoryDetailsHistoryDetailsProtocols.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol HistoryDetailsViewInput: class, Presentable {
    func setupInitialState(_ model: HistoryDetailsScreenModel)
}

protocol HistoryDetailsViewOutput {
    func viewIsReady()
    func actionBack()
    func actionOpenInExplorer(type: HistoryDetailsExplorerType)
}

protocol HistoryDetailsModuleInput: class {
	var viewController: UIViewController { get }
	var output: HistoryDetailsModuleOutput? { get set }
    
    func setTransaction(_ transaction: BTCWalletHistoryModel)
}

protocol HistoryDetailsModuleOutput: class {
    func didSelectExplorer(url: URL)
}

protocol HistoryDetailsInteractorInput {
    func setTransaction(_ transaction: BTCWalletHistoryModel)
    func getScreenModel() -> HistoryDetailsScreenModel
    func getExplorerUrl(type: HistoryDetailsExplorerType) -> URL?
}

protocol HistoryDetailsInteractorOutput: class {
}

protocol HistoryDetailsRouterInput {
}
