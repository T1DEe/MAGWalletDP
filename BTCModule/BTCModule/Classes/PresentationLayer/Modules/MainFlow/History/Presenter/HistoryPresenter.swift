//
//  HistoryHistoryPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class HistoryPresenter {
    weak var view: HistoryViewInput!
    weak var output: HistoryModuleOutput?
    
    var interactor: HistoryInteractorInput!
    var router: HistoryRouterInput!
    
    func setupInitialState() {
        view.setupState(state: .loading)
        interactor.loadHistoryFromStart()
    }
}

// MARK: - HistoryModuleInput

extension HistoryPresenter: HistoryModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
    
    func offsetDidChange(offset: CGFloat) {
        view.setupTopOffset(offset: offset)
    }
}

// MARK: - HistoryViewOutput

extension HistoryPresenter: HistoryViewOutput {
    func actionEndDragging() {
        output?.scrollViewDidEndDeselerating()
    }
    
    func offsetDidChangeAction(offset: CGFloat) {
        output?.scrollTopOffsetDidChange(offset: offset)
    }
    
    func loadMoreHistory() {
        interactor.loadNextHistoryPage()
    }
    
    func actionSelectTransaction(item: BTCHistoryEntity) {
        guard let transaction = interactor.getOriginalTransaction(transaction: item) else {
            return
        }
        router.showDetails(transaction: transaction, output: self)
    }
    
    func refreshHistory() {
        interactor.loadHistoryFromStart()
    }
    
    func viewIsReady() {
        interactor.bindToEvents()
        setupInitialState()
    }
    
    func actionRetryLoadHistory() {
        view.setupState(state: .loading)
        interactor.loadHistoryFromStart()
    }
}

// MARK: - HistoryInteractorOutput

extension HistoryPresenter: HistoryInteractorOutput {
    func didNewWalletSelected() {
        setupInitialState()
    }
    
    func historyLoaded(responce: PagedResponse<BTCHistoryEntity>) {
        if responce.data.isEmpty == false {
            view.setupState(state: .loaded(responce: responce))
        } else {
            view.setupState(state: .empty)
        }
    }
    
    func newTransactionsLoaded(responce: PagedResponse<BTCHistoryEntity>) {
        view.setupNewTransactions(responce: responce)
    }
    
    func historyLoadFailed() {
        view.setupState(state: .errorLoading)
    }
}

extension HistoryPresenter: HistoryDetailsModuleOutput {
    func didSelectExplorer(url: URL) {
        output?.didSelectExplorer(url: url)
    }
}
