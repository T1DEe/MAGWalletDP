//
//  HistoryHistoryPresenter.swift
//  ETHModule
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
    
    var currentCurrency: Currency?
    var currencies: [Currency]!
    
    func setupInitialState() {
        view.setupState(state: .loading)
        let hasAdditionalToken = interactor.hasAdditionalToken()
        view.setupHeaderState(hasToken: hasAdditionalToken)
        currencies = interactor.getAllCurrencies()
        currentCurrency = currencies.first
        if let currency = currentCurrency {
            if hasAdditionalToken {
                view.setupInteractiveState(state: currency.isToken ? .token : .currency)
            } else {
                view.setupInteractiveState(state: .onlyCurrency)
            }
            interactor.loadHistoryFromStart(for: currency)
        }
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
    
    func presentCurrencySnackBar() {
        if let currency = currentCurrency {
            presentSnackBar(with: currencies, selectedCurrency: currency)
        } else {
            if let currency = currencies.first {
                presentSnackBar(with: currencies, selectedCurrency: currency)
            }
        }
    }
    
    func setSelectedCurrency(_ currency: Currency) {
        if currency != currentCurrency {
            view.setupState(state: .loading)
            interactor.loadHistoryFromStart(for: currency)
        }
        view.setupInteractiveState(state: currency.isToken ? .token : .currency)
        currentCurrency = currency
    }
    
    func setSelectionCanceled() {
        if let isToken = currentCurrency?.isToken {
            view.setupInteractiveState(state: isToken ? .token : .currency)
        }
    }
    
    private func presentSnackBar(with currencies: [Currency], selectedCurrency: Currency) {
        let selectCurrencyModule = router.getCurrencySnackBar()
        selectCurrencyModule.output = self
        let payModel = PayCurrenciesModel(echoAssetsAndTokens: currencies)
        selectCurrencyModule.setCurrencies(payModel)
        selectCurrencyModule.setSelectedCurrency(selectedCurrency)
        interactor.presentSnackbar(snackBar: selectCurrencyModule)
    }
}

// MARK: - HistoryViewOutput

extension HistoryPresenter: HistoryViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        setupInitialState()
    }
    
    func loadMoreHistory() {
        guard let currency = currentCurrency else {
            return
        }
        interactor.loadNextHistoryPage(for: currency)
    }
    
    func refreshHistory() {
        guard let currency = currentCurrency else {
            return
        }
        interactor.loadHistoryFromStart(for: currency)
    }
    
    func actionSelectTransaction(item: EthHistoryModel) {
        guard let currency = currentCurrency else {
            return
        }
        if currency.isToken {
            if let transaction = interactor.getTokenHistoryOriginalTransaction(transaction: item) {
                router.showDetails(transaction: transaction, output: self)
            }
        } else {
            if let transaction = interactor.getHistoryOriginalTransaction(transaction: item) {
                router.showDetails(transaction: transaction, output: self)
            }
        }
    }
    
    func actionRetryLoadHistory() {
        guard let currency = currentCurrency else {
            return
        }
        view.setupState(state: .loading)
        interactor.loadHistoryFromStart(for: currency)
    }
    
    func actionEndDragging() {
        output?.scrollViewDidEndDeselerating()
    }
    
    func offsetDidChangeAction(offset: CGFloat) {
        output?.scrollTopOffsetDidChange(offset: offset)
    }
}

// MARK: - HistoryDetailsModuleOutput

extension HistoryPresenter: HistoryDetailsModuleOutput {
    func didSelectExplorer(url: URL) {
        output?.didSelectExplorer(url: url)
    }
}

// MARK: - HistoryInteractorOutput

extension HistoryPresenter: HistoryInteractorOutput {
    func didNewWalletSelected() {
        setupInitialState()
    }
    
    func historyLoaded(responce: PagedResponse<EthHistoryModel>) {
        if responce.data.isEmpty {
            let hasToken = interactor.hasAdditionalToken()
            view.setupState(state: .empty(shouldHideHeader: !hasToken))
        } else {
            view.setupState(state: .loaded(responce: responce))
        }
    }
    
    func historyLoadFailed() {
        view.setupState(state: .errorLoading)
    }
    
    func newTransactionsLoaded(responce: PagedResponse<EthHistoryModel>) {
        view.setupNewTransactions(responce: responce)
    }
}

extension HistoryPresenter: SelectCurrencySnackBarModuleOutput {
    func currencySelected(_ currency: Currency) {
        setSelectedCurrency(currency)
    }
    
    func selectionCanceled() {
        setSelectionCanceled()
    }
}
