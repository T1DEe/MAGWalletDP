//
//  HistoryHistoryProtocols.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

enum HistoryState {
    case loading
    case errorLoading
    case empty
    case loaded(responce: PagedResponse<BTCHistoryEntity>)
}

protocol HistoryViewInput: class, Presentable {
    func setupState(state: HistoryState)
    func setupNewTransactions(responce: PagedResponse<BTCHistoryEntity>)
    func setupTopOffset(offset: CGFloat)
    func setupViewInsets(insets: CGFloat)
}

protocol HistoryViewOutput {
    func viewIsReady()
    func actionRetryLoadHistory()
    func refreshHistory()
    func actionSelectTransaction(item: BTCHistoryEntity)
    func loadMoreHistory()
    func offsetDidChangeAction(offset: CGFloat)
    func actionEndDragging()
}

protocol HistoryModuleInput: class {
	var viewController: UIViewController { get }
	var output: HistoryModuleOutput? { get set }
    
    func offsetDidChange(offset: CGFloat)
}

protocol HistoryModuleOutput: class {
    func scrollTopOffsetDidChange(offset: CGFloat)
    func scrollViewDidEndDeselerating()
    func didSelectExplorer(url: URL)
}

protocol HistoryInteractorInput {
    func bindToEvents()
    func loadHistoryFromStart()
    func loadNextHistoryPage()
    func getOriginalTransaction(transaction: BTCHistoryEntity) -> BTCWalletHistoryModel?
    func hasBTCAccount() -> Bool
}

protocol HistoryInteractorOutput: class {
    func historyLoadFailed()
    func didNewWalletSelected()
    func historyLoaded(responce: PagedResponse<BTCHistoryEntity>)
    func newTransactionsLoaded(responce: PagedResponse<BTCHistoryEntity>)
}

protocol HistoryRouterInput {
    func showDetails(transaction: BTCWalletHistoryModel, output: HistoryDetailsModuleOutput)
}
