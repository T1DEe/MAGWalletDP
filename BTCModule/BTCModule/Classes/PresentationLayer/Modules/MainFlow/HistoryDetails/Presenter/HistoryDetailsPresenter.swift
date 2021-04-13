//
//  HistoryDetailsHistoryDetailsPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class HistoryDetailsPresenter {
    weak var view: HistoryDetailsViewInput!
    weak var output: HistoryDetailsModuleOutput?
    
    var interactor: HistoryDetailsInteractorInput!
    var router: HistoryDetailsRouterInput!
}

// MARK: - HistoryDetailsModuleInput

extension HistoryDetailsPresenter: HistoryDetailsModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func setTransaction(_ transaction: BTCWalletHistoryModel) {
        interactor.setTransaction(transaction)
    }
}

// MARK: - HistoryDetailsViewOutput

extension HistoryDetailsPresenter: HistoryDetailsViewOutput {
    func viewIsReady() {
        let model = interactor.getScreenModel()
        view.setupInitialState(model)
    }
    
    func actionBack() {
        view.dissmiss()
    }
    
    func actionOpenInExplorer(type: HistoryDetailsExplorerType) {
        guard let url = interactor.getExplorerUrl(type: type) else {
            return
        }
        output?.didSelectExplorer(url: url)
    }
}

// MARK: - HistoryDetailsInteractorOutput

extension HistoryDetailsPresenter: HistoryDetailsInteractorOutput {
}
