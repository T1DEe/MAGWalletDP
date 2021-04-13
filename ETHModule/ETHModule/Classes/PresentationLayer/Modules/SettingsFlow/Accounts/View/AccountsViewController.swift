//
//  AccountsAccountsViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class AccountsViewController: UIViewController {
    var output: AccountsViewOutput!

    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private let sectionHeaderHeight: CGFloat = 40.0
    private let rowHeight: CGFloat = 75.0
    private let gradientHeight: CGFloat = 20
    
    var model: AccountsScreenModel?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()

        config()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calculateTableViewHeight()
    }

    // MARK: - Configuration

    private func config() {
        configTableView()
        configColors()
        configButton()
        configLocalization()
        configTopGradientView()
        configBottomGradientView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero,
                                                         size: CGSize(width: self.view.frame.width,
                                                                      height: CGFloat.leastNormalMagnitude)))
        tableView.tableFooterView = UIView(frame: CGRect(origin: .zero,
                                                         size: CGSize(width: self.view.frame.width,
                                                                      height: CGFloat.leastNormalMagnitude)))
    }

    private func configColors() {
        view.backgroundColor = R.color.gray2()
    }

    private func configButton() {
        backButton.image = R.image.backIcon()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionCancel()
        }
    }

    private func configLocalization() {
        titleLabel.text = R.string.localization.settingsFlowAccountsTitle()
        subtitleLabel.text = R.string.localization.accountsScreenSubtitle()
    }

    private func configTopGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = topGradientView.bounds
        topGradientView.layer.mask = gradient
        topGradientView.alpha = 0
    }

    private func configBottomGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = bottomGradientView.bounds
        bottomGradientView.layer.mask = gradient
    }

    private func calculateTableViewHeight() {
        var maxTableHeight = self.view.frame.height - tableView.frame.origin.y
        var bottomOffset: CGFloat = 16
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom, bottomPadding > 0 {
                bottomOffset = bottomPadding
            }
        }
        maxTableHeight -= bottomOffset
        
        let height = CGFloat(model?.accounts.count ?? 0) * rowHeight
        if height <= maxTableHeight {
            tableViewHeight.constant = height
            tableView.isScrollEnabled = false
        } else {
            tableViewHeight.constant = maxTableHeight
            tableView.isScrollEnabled = true
        }
        var array = [UIView]()
        array.removeAll { $0.isHidden == true }
        bottomGradientView.alpha = tableView.isScrollEnabled ? 1.0 : 0.0
    }

    // MARK: - Actions

    @IBAction func actionAddAccount(_ sender: Any) {
        output.actionAddAccount()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.accounts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ethAccountsCellIdentifier,
                                                       for: indexPath) else {
            return UITableViewCell()
        }

        guard let model = model else {
            return UITableViewCell()
        }
        
        let accountModel = model.accounts[indexPath.row]
        cell.accountNameLabel.text = accountModel.wallet.address
        cell.tokenAmountLabel.attributedText = accountModel.tokentBalance
        cell.currencyAmountLabel.attributedText = accountModel.balance
        cell.selectedIcon.isHidden = !accountModel.isCurrent
        
        cell.delegate = self
        cell.account = accountModel

        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = model else {
            return
        }
        
        let account = model.accounts[indexPath.row]
        if account.isCurrent {
            return
        }
        
        output.actionSelectAccountAsCurrent(account)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomOffset = tableView.contentOffset.y + tableView.frame.height
        let diff = tableView.contentSize.height - bottomOffset

        topGradientView.alpha = tableView.contentOffset.y / gradientHeight
        bottomGradientView.alpha = diff / gradientHeight
    }
}

// MARK: - EchoAccountsCellDelegate

extension AccountsViewController: EthAccountsCellDelegate {
    func didDeleteAccount(_ account: AccountsScreenAccountModel) {
        output.actionDeleteAccount(account)
    }
}

// MARK: - AccountsViewInput

extension AccountsViewController: AccountsViewInput {
	func setupInitialState(model: AccountsScreenModel) {
        self.model = model
        tableView.reloadData()
        calculateTableViewHeight()
    }
}
