//
//  HistoryHistoryProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum WalletTokenState {
    case currency
    case token
    case onlyCurrency
}

enum HistoryState {
    case loading
    case errorLoading
    case empty(shouldHideHeader: Bool)
    case loaded(responce: PagedResponse<EthHistoryModel>)
}

protocol HistoryViewInput: class, Presentable {
    func setupState(state: HistoryState)
    func setupNewTransactions(responce: PagedResponse<EthHistoryModel>)
    func setupTopOffset(offset: CGFloat)
    func setupViewInsets(insets: CGFloat)
    func setupHeaderState(hasToken: Bool)
    func setupInteractiveState(state: WalletTokenState)
}

protocol HistoryViewOutput {
    func viewIsReady()
    func loadMoreHistory()
    func refreshHistory()
    func actionSelectTransaction(item: EthHistoryModel)
    func actionRetryLoadHistory()
    func offsetDidChangeAction(offset: CGFloat)
    func actionEndDragging()
    func presentCurrencySnackBar()
}

protocol HistoryModuleInput: class {
	var viewController: UIViewController { get }
	var output: HistoryModuleOutput? { get set }
    
    func offsetDidChange(offset: CGFloat)
    func presentCurrencySnackBar()
    func setSelectedCurrency(_ currency: Currency)
    func setSelectionCanceled()
}

protocol HistoryModuleOutput: class {
    func scrollViewDidEndDeselerating()
    func scrollTopOffsetDidChange(offset: CGFloat)
    func didSelectExplorer(url: URL)
}

protocol HistoryInteractorInput {
    func bindToEvents()
    func loadHistoryFromStart(for currency: Currency)
    func loadNextHistoryPage(for currency: Currency)
    func hasEthAccount() -> Bool
    func getHistoryOriginalTransaction(transaction: EthHistoryModel) -> ETHWalletHistoryEntity?
    func getTokenHistoryOriginalTransaction(transaction: EthHistoryModel) -> TokenHistoryEntity?
    func hasAdditionalToken() -> Bool
    func getAllCurrencies() -> [Currency]
    func presentSnackbar(snackBar: SnackBarPresentable)
}

protocol HistoryInteractorOutput: class {
    func didNewWalletSelected()
    func historyLoaded(responce: PagedResponse<EthHistoryModel>)
    func historyLoadFailed()
    func newTransactionsLoaded(responce: PagedResponse<EthHistoryModel>)
}

protocol HistoryRouterInput {
    func showDetails(transaction: TokenHistoryEntity, output: HistoryDetailsModuleOutput)
    func getCurrencySnackBar() -> SelectCurrencySnackBarModuleInput
    func showDetails(transaction: ETHWalletHistoryEntity, output: HistoryDetailsModuleOutput)
}
