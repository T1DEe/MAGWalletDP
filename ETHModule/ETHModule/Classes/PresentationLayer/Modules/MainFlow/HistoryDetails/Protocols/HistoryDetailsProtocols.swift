//
//  HistoryDetailsProtocols.swift
//  ETHModule
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
    func actionOpenInExplorerFromHeader()
    func actionOpenInExplorerFromValue(value: String)
}

protocol HistoryDetailsModuleInput: class {
	var viewController: UIViewController { get }
	var output: HistoryDetailsModuleOutput? { get set }
    
    func setTransaction(_ transaction: ETHWalletHistoryEntity)
    func setTransaction(_ transaction: TokenHistoryEntity)
}

protocol HistoryDetailsModuleOutput: class {
    func didSelectExplorer(url: URL)
}

protocol HistoryDetailsInteractorInput {
    func setTransaction(_ transaction: ETHWalletHistoryEntity)
    func setTransaction(_ transaction: TokenHistoryEntity)
    func getScreenModel() -> HistoryDetailsScreenModel?
    func getUrlWithTransactionHash() -> URL?
    func getUrlWithAddress(address: String) -> URL?
}

protocol HistoryDetailsInteractorOutput: class {
}

protocol HistoryDetailsRouterInput {
}
