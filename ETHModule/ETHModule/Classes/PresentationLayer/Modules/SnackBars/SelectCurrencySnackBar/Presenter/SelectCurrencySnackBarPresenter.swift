//
//  SelectCurrencySnackBarPresenter.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class SelectCurrencySnackBarPresenter {
    weak var view: SelectCurrencySnackBarViewInput!
    weak var output: SelectCurrencySnackBarModuleOutput?
    weak var dismissDelegate: SnackBarPresentableDelegate?
    
    var interactor: SelectCurrencySnackBarInteractorInput!
    var router: SelectCurrencySnackBarRouterInput!
    
    var isFullScreen: Bool = true
    var needAddSwipeForClose: Bool = false
    
    var currencies: PayCurrenciesModel!
    var selectedCurrency: Currency!
}

// MARK: - SelectCurrencySnackBarModuleInput

extension SelectCurrencySnackBarPresenter: SelectCurrencySnackBarModuleInput {
    func didDismiss() { }
    
    var snackBarView: UIView {
        if let viewController = viewController as? SelectCurrencySnackBarViewController {
            _ = viewController.view
            return viewController.containerView
        }
        return viewController.view
    }
    
    var snackBarViewController: UIViewController {
        return viewController
    }
    
  	var viewController: UIViewController {
    	return view.viewController
    }
    
    func setCurrencies(_ currencies: PayCurrenciesModel) {
        self.currencies = currencies
    }
    
    func setSelectedCurrency(_ currency: Currency) {
        self.selectedCurrency = currency
    }
}

// MARK: - SelectCurrencySnackBarViewOutput

extension SelectCurrencySnackBarPresenter: SelectCurrencySnackBarViewOutput {
    func viewIsReady() {
        view.setupInitialState(currencies: currencies, selectedCurrency: selectedCurrency)
    }
    
    func actionClose() {
        output?.selectionCanceled()
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
    
    func actionSelectCurrency(_ currency: Currency) {
        output?.currencySelected(currency)
        dismissDelegate?.dismissSnackBar(snackBar: self)
    }
}

// MARK: - SelectCurrencySnackBarInteractorOutput

extension SelectCurrencySnackBarPresenter: SelectCurrencySnackBarInteractorOutput {
}
