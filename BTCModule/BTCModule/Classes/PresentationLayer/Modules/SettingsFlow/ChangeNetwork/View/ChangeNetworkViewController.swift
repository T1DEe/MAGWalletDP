//
//  ChangeNetworkViewController.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

class ChangeNetworkViewController: UIViewController {
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToBackButtonConstraint: NSLayoutConstraint!
    
    private let sectionHeaderHeight: CGFloat = 40.0
    private let cellHeight: CGFloat = 60.0
    private let topTableViewConstant: CGFloat = 48.0
    private let titleLabelTopConstant: CGFloat = 54.0
    fileprivate var models = [ChangeNetworkModel<BTCNetworkType>]()
    
    var output: ChangeNetworkViewOutput!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: Configuration
    
    private func config() {
        configTableView()
        configColors()
        configButton()
        configLocalization()
        configGradientView()
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        
        headerTitleLabel.isHidden = true
        gradientView.isHidden = true
    }
    
    private func configButton() {
        backButton.image = R.image.backIcon()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.settingsFlowNetworks()
        headerTitleLabel.text = R.string.localization.settingsFlowNetworks()
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(
            top: topTableViewConstant,
            left: 0,
            bottom: 0,
            right: 0
        )
        tableView.backgroundColor = .clear
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

// MARK: - TableView Data Source

extension ChangeNetworkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.changeNetworkTableViewCell.identifier,
                                                       for: indexPath) as? ChangeNetworkTableViewCell else {
            return UITableViewCell()
        }
        let model = models[indexPath.row]
        cell.nameLabel.text = model.name
        cell.nameLabel.textColor = R.color.dark()
        
        if model.isSelected {
            cell.cellContentView.backgroundColor = R.color.gray1()?.withAlphaComponent(0.1)
            cell.selectionImageView.isHidden = false
        } else {
            cell.cellContentView.backgroundColor = .clear
            cell.selectionImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        if !model.isSelected {
            output.actionSelectNetwork(model: model)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.changeNetworkHeaderCellIdentifier.identifier)
            as? ChangeNetworkHeaderCell else {
            return nil
        }
        
        cell.titleLabel.text = R.string.localization.networkGroupTitle()
        cell.backgroundColor = R.color.gray2()
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
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

// MARK: - ChangeNetworkViewInput

extension ChangeNetworkViewController: ChangeNetworkViewInput {
    func setupInitialState(with models: [ChangeNetworkModel<BTCNetworkType>]) {
        self.models = models
        tableView.reloadData()
    }
}
