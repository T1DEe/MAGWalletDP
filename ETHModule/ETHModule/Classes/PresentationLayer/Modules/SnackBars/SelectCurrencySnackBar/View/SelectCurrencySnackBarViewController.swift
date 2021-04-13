//
//  SelectCurrencySnackBarViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class SelectCurrencySnackBarViewController: UIViewController {
    var output: SelectCurrencySnackBarViewOutput!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currencies: PayCurrenciesModel!
    var selectedCurrency: Currency!
    
    fileprivate let cellHeight: CGFloat = 46
    fileprivate let tableTopInset: CGFloat = 1
    fileprivate let headerHeight: CGFloat = 1
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: Config
    
    func config() {
        configColors()
        configFonts()
        configLocalization()
        configTable()
    }
    
    func configColors() {
        containerView.backgroundColor = R.color.purple()
        titleLabel.textColor = R.color.gray2()?.withAlphaComponent(0.3)
    }
    
    func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 14)
    }
    func configLocalization() {
        titleLabel.text = R.string.localization.sendFlowCurrencyPopupTitle()
    }
    
    func configTable() {
        tableView.register(
            UINib(resource: R.nib.selectCurrencySnackBarTableViewCell),
            forCellReuseIdentifier: R.nib.selectCurrencySnackBarTableViewCell.name
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func actionClose(_ sender: Any) {
        output.actionClose()
    }
    
    // MARK: Private
    
    fileprivate func setupEchoCurrencyCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: R.nib.selectCurrencySnackBarTableViewCell.name,
            for: indexPath) as? SelectCurrencySnackBarTableViewCell else {
            return UITableViewCell()
        }
        let currency = currencies.echoAssetsAndTokens[indexPath.row]
        let isLast = currencies.echoAssetsAndTokens.count == indexPath.row + 1
        configCellByCurrency(cell, currency: currency, isLast: isLast)
        return cell
    }
    
    private func configCellByCurrency(_ cell: SelectCurrencySnackBarTableViewCell, currency: Currency, isLast: Bool) {
        cell.symbolLabel.text = currency.symbol
        cell.nameLabel.text = currency.name
        
        let selected = currency.id == selectedCurrency.id
        if selected {
            cell.setSeleced()
        } else {
            cell.setDeselected()
        }
        
        if isLast {
            cell.setLast()
        }
    }
}

extension SelectCurrencySnackBarViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.echoAssetsAndTokens.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupEchoCurrencyCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.actionSelectCurrency(currencies.echoAssetsAndTokens[indexPath.row])
    }
}

// MARK: - SelectCurrencySnackBarViewInput

extension SelectCurrencySnackBarViewController: SelectCurrencySnackBarViewInput {
    func setupInitialState(currencies: PayCurrenciesModel, selectedCurrency: Currency) {
        self.selectedCurrency = selectedCurrency
        self.currencies = currencies
        tableView.reloadData()
    }
}
