//
//  SelectCurrencySnackBarProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol SelectCurrencySnackBarViewInput: class, Presentable {
    func setupInitialState(currencies: PayCurrenciesModel, selectedCurrency: Currency)
}

protocol SelectCurrencySnackBarViewOutput {
    func viewIsReady()
    
    func actionClose()
    func actionSelectCurrency(_ currency: Currency)
}

protocol SelectCurrencySnackBarModuleInput: SnackBarPresentable {
	var viewController: UIViewController { get }
	var output: SelectCurrencySnackBarModuleOutput? { get set }
    
    func setCurrencies(_ currencies: PayCurrenciesModel)
    func setSelectedCurrency(_ currency: Currency)
}

protocol SelectCurrencySnackBarModuleOutput: class {
    func currencySelected(_ currency: Currency)
    func selectionCanceled()
}

protocol SelectCurrencySnackBarInteractorInput {
}

protocol SelectCurrencySnackBarInteractorOutput: class {
}

protocol SelectCurrencySnackBarRouterInput {
}
