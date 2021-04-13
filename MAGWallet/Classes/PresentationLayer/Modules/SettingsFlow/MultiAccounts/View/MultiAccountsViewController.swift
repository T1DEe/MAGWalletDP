//
//  MultiAccountsMultiAccountsViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class MultiAccountsViewController: UIViewController {
    var output: MultiAccountsViewOutput!

    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableViewToBackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountSpacingConstraint: NSLayoutConstraint!
    
    private let sectionHeaderHeight: CGFloat = 40.0
    private let rowHeight: CGFloat = 75.0
    private let topTableViewConstant: CGFloat = 48.0
    private let titleLabelTopConstant: CGFloat = 54.0

    var entity: MultiAccountsScreenModel!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()

        config()
    }

    // MARK: - Configuration

    private func config() {
        configTableView()
        configColors()
        configButton()
        configLocalization()
        configGradientView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: topTableViewConstant,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        tableView.backgroundColor = .clear
    }

    private func configColors() {
        view.backgroundColor = R.color.gray2()
        
        headerTitleLabel.isHidden = true
        gradientView.isHidden = true
    }

    private func configButton() {
        backButton.image = R.image.back()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }

    private func configLocalization() {
        titleLabel.text = R.string.localization.settingsFlowMultiaccountsScreenTitle()
        headerTitleLabel.text = R.string.localization.settingsFlowMultiaccountsScreenTitle()
    }

    private func setupCell(indexPath: IndexPath, account: MultiAccountsScreenAccountModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.accountsCellIdentifier, for: indexPath) else {
            return UITableViewCell()
        }
        if account.tokentBalance == nil {
            cell.setNoTokenLayout()
        }
        
        cell.delegate = self
        cell.accountNameLabel.text = account.accountName
        cell.amountLabel.attributedText = account.balance
        cell.tokenAmountLabel.attributedText = account.tokentBalance
        cell.selectedIcon.isHidden = !account.isCurrent
        cell.sectionIndex = indexPath.section
        cell.cellIndex = indexPath.row

        return cell
    }

    private func customLayoutForGroupedCells(cell: UITableViewCell, indexPath: IndexPath) {
        let cornerRadius: CGFloat = 12.0
        cell.backgroundColor = .clear
        let layer: CAShapeLayer = CAShapeLayer()
        let path: CGMutablePath = CGMutablePath()
        let bounds: CGRect = cell.bounds
        let separatorColor = R.color.gray1()?.withAlphaComponent(0.5)
        var addLine: Bool = false

        if indexPath.row == 0 && indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
            path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
                        tangent2End: CGPoint(x: bounds.midX, y: bounds.minY),
                        radius: cornerRadius)
            path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
                        tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                        radius: cornerRadius)
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                        tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                        radius: cornerRadius)
            path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                        tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                        radius: cornerRadius)
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        } else {
            path.addRect(bounds)
            addLine = true
        }

        layer.path = path
        layer.fillColor = UIColor.white.withAlphaComponent(0.8).cgColor

        if addLine {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
            lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
            lineLayer.backgroundColor = separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }

        let testView: UIView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        cell.backgroundView = testView
    }

    private func configGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = gradientView.bounds
        gradientView.layer.mask = gradient
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MultiAccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if entity == nil {
            return 0
        }
        return entity.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entity.sections[section].accounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = entity.sections[indexPath.section].accounts[indexPath.row]
        return setupCell(indexPath: indexPath, account: account)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = entity.sections[indexPath.section]
        let account = section.accounts[indexPath.row]
        let holder = section.accountsHolder
        
        guard !account.isCurrent else {
            return
        }
        
        output.actionSelectAccountAsCurrent(account, accountsHolder: holder)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.addAccountHeaderCellIdentifier.identifier)
            as? AddAccountHeaderCell else {
            return nil
        }

        let header = entity.sections[section].headerModel

        cell.delegate = self
        cell.backgroundColor = R.color.gray2()
        cell.titleLabel.text = header.title
        cell.secionIndex = section

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        customLayoutForGroupedCells(cell: cell, indexPath: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titleValue = titleLabelTopConstant - scrollView.contentOffset.y - tableView.contentInset.top
        
        if titleValue < 16 {
            titleLabelTopConstraint.constant = 0
            gradientView.isHidden = false
            headerTitleLabel.isHidden = false
        } else if titleValue > 0 && titleValue < titleLabelTopConstant {
            titleLabelTopConstraint.constant = titleValue
            gradientView.isHidden = true
            headerTitleLabel.isHidden = true
        } else if titleValue > titleLabelTopConstant {
            titleLabelTopConstraint.constant = titleLabelTopConstant
            gradientView.isHidden = true
            headerTitleLabel.isHidden = true
        }
    }
}

// MARK: - AddAccountDelegate

extension MultiAccountsViewController: AddAccountDelegate {
    func didAddAccount(sectionIndex: Int) {
        let holder = entity.sections[sectionIndex].accountsHolder
        output.actionAddAccount(accountsHolder: holder)
    }
}

// MARK: - AccountsCell

extension MultiAccountsViewController: AccountWithTokenDelegate {
    func didDelete(sectionIndex: Int, cellIndex: Int) {
        let section = entity.sections[sectionIndex]
        let account = section.accounts[cellIndex]
        let holder = section.accountsHolder
        output.actionDeleteAccount(account, accountsHolder: holder)
    }
}

// MARK: - MultiAccountsViewInput

extension MultiAccountsViewController: MultiAccountsViewInput {
    func setupInitialState(model: MultiAccountsScreenModel) {
        self.entity = model
        self.tableView.reloadData()
    }
}
