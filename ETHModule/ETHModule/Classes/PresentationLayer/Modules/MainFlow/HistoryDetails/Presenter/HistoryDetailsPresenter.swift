//
//  HistoryDetailsPresenter.swift
//  ETHModule
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
    
    func setTransaction(_ transaction: ETHWalletHistoryEntity) {
        interactor.setTransaction(transaction)
    }
    
    func setTransaction(_ transaction: TokenHistoryEntity) {
        interactor.setTransaction(transaction)
    }
}

// MARK: - HistoryDetailsViewOutput

extension HistoryDetailsPresenter: HistoryDetailsViewOutput {
    func viewIsReady() {
        guard let model = interactor.getScreenModel() else {
            return
        }
        view.setupInitialState(model)
    }
    
    func actionBack() {
        view.dissmiss()
    }

    func actionOpenInExplorerFromHeader() {
        guard let url = interactor.getUrlWithTransactionHash() else {
            return
        }
        output?.didSelectExplorer(url: url)
    }

    func actionOpenInExplorerFromValue(value: String) {
        guard let url = interactor.getUrlWithAddress(address: value) else {
            return
        }
        output?.didSelectExplorer(url: url)
    }
}

// MARK: - HistoryDetailsInteractorOutput

extension HistoryDetailsPresenter: HistoryDetailsInteractorOutput {
}
