//
//  AllCurrenciesAllCurrenciesViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class AllCurrenciesViewController: UIViewController {
    var output: AllCurrenciesViewOutput!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var settingsButton: ImageButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: GradientView!
    var highlightCell: UITableViewCell?
    let singleCurrencyCellHeight: CGFloat = 116
    let doubleCurrencyCellHeight: CGFloat = 214
    let emptyCurrencyCellHeight: CGFloat = 84

    var models = [AllCurrenciesScreenModel]()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsReadyToShow()
    }
    
    // MARK: Config
    
    func config() {
        cofigColors()
        configFonts()
        configLocalization()
        configButtons()
        configTable()
    }
    
    func cofigColors() {
        view.backgroundColor = R.color.gray2()
        tableView.backgroundColor = .clear
        titleLabel.textColor = R.color.dark()
        subtitleLabel.textColor = R.color.gray1()
        
        gradientView.fromColor = R.color.gray2()
        gradientView.toColor = UIColor.white.withAlphaComponent(0)
    }
    
    func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 22)
        subtitleLabel.font = R.font.poppinsRegular(size: 16)
    }
    
    func configLocalization() {
        titleLabel.text = R.string.localization.allCurrenciesTitle().capitalized
        subtitleLabel.text = R.string.localization.allCurrenciesSubtitle()
    }
    
    func configButtons() {
        settingsButton.image = R.image.icSettings()
        settingsButton.touchUpInside = { [weak self] _ in
            self?.actionSettings()
        }
    }
    
    func configTable() {
        tableView.register(R.nib.allCurrenciesSingleTableViewCell)
        tableView.register(R.nib.allCurrenciesDuoTableViewCell)
        tableView.register(R.nib.allCurrenciesEmptyTableViewCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let subtitleMaxY = subtitleLabel.frame.maxY
        tableView.contentInset = UIEdgeInsets(top: subtitleMaxY + 50,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        tableView.alwaysBounceVertical = false
    }
    
    func updateHighlightCell() {
        // cell not updating its transform when highlighted and then reload data
        highlightCell?.transform = CGAffineTransform.identity
    }
    
    // MARK: Actions
    
    func actionSettings() {
        output.actionSettings()
    }
}

extension AllCurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = models[indexPath.row]
        
        if model is AllCurrenciesScreenSingleModel {
            return singleCurrencyCellHeight
        }
        
        if model is AllCurrenciesScreenDuoModel {
            return doubleCurrencyCellHeight
        }
        
        if model is AllCurrenciesScreenEmptyModel {
            return emptyCurrencyCellHeight
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        if let single = model as? AllCurrenciesScreenSingleModel {
            return configSingleCell(model: single, tableView: tableView, indexPath: indexPath)
        }
        
        if let duo = model as? AllCurrenciesScreenDuoModel {
            return configDuoCell(model: duo, tableView: tableView, indexPath: indexPath)
        }
        
        if let empty = model as? AllCurrenciesScreenEmptyModel {
            return configEmptyCell(model: empty, tableView: tableView, indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
    func configSingleCell(model: AllCurrenciesScreenSingleModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let identifier = R.nib.allCurrenciesSingleTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AllCurrenciesSingleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.iconImageView.image = model.currency.icon
        cell.nameLabel.text = model.currency.name
        cell.amountLabel.attributedText = getAttributedStringForBalance(
            symbol: model.balance.symbol,
            amount: model.balance.amount
        )
        cell.rateLabel.text = model.rate.symbol + model.rate.amount
        
        return cell
    }
    
    func configDuoCell(model: AllCurrenciesScreenDuoModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let identifier = R.nib.allCurrenciesDuoTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AllCurrenciesDuoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.firstIconImageView.image = model.firstCurrency.icon
        cell.firstNameLabel.text = model.firstCurrency.name
        cell.firstAmountLabel.attributedText = getAttributedStringForBalance(
            symbol: model.firstBalance.symbol,
            amount: model.firstBalance.amount
        )
        cell.firstRateLabel.text = model.firstRate.symbol + model.firstRate.amount
        
        cell.secondIconImageView.image = model.secondCurrency.icon
        cell.secondNameLabel.text = model.secondCurrency.name
        cell.secondAmountLabel.attributedText = getAttributedStringForBalance(
            symbol: model.secondBalance.symbol,
            amount: model.secondBalance.amount
        )
        cell.secondRateLabel.text = model.secondRate.symbol + model.secondRate.amount
        
        return cell
    }
    
    func configEmptyCell(model: AllCurrenciesScreenEmptyModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let identifier = R.nib.allCurrenciesEmptyTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AllCurrenciesEmptyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.iconImageView.image = model.currency.icon
        cell.nameLabel.text = model.currency.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            highlightCell = cell
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.1) {
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        if let account = model.additionObject {
            output.actionSelectAccount(account: account)
        }
    }
    
    // MARK: Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let defaultY = subtitleLabel.frame.maxY + 50
        let current = defaultY - (offset + scrollView.contentInset.top)
        
        let subtitleAlpha = (current - subtitleLabel.frame.maxY) / (defaultY - subtitleLabel.frame.maxY)
        subtitleLabel.alpha = subtitleAlpha
        let titleAlpha = (current - titleLabel.frame.maxY) / (defaultY - titleLabel.frame.maxY)
        titleLabel.alpha = titleAlpha
    }
}

// MARK: - AllCurrenciesViewInput

extension AllCurrenciesViewController: AllCurrenciesViewInput {
    func setupInitialState(models: [AllCurrenciesScreenModel]) {
        self.models = models
        tableView.reloadData()
  	}
    
    func updateConrols() {
        tableView.reloadData()
        updateHighlightCell()
    }
}

extension AllCurrenciesViewController {
    private func getAttributedStringForBalance(symbol: String, amount: String) -> NSAttributedString {
        let balance = NSMutableAttributedString(
            string: amount,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 20) ?? UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: R.color.dark() ?? .blue
            ]
        )
        
        let currency = NSMutableAttributedString(
            string: " " + symbol,
            attributes: [
                NSAttributedString.Key.font: R.font.poppinsMedium(size: 12) ?? UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: R.color.gray1() ?? .blue
            ]
        )
        
        balance.append(currency)
        return balance
    }
}
