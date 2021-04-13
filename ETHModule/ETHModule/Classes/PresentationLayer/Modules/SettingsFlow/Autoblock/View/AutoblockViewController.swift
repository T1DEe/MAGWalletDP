//
//  AutoblockAutoblockViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

class AutoblockViewController: UIViewController {
    var output: AutoblockViewOutput!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var backButton: ImageButton!
    fileprivate var models = [AutoblockModel]()
    fileprivate let cellHeight: CGFloat = 60.0
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        output.viewIsReady()
    }
    
    // MARK: Configuration
    
    private func config() {
        configTableView()
        configFonts()
        configColors()
        configButton()
        configLocalization()
    }
    
    private func configFonts() {
        infoLabel.font = R.font.poppinsMedium(size: 22)
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        infoLabel.textColor = R.color.dark()
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
        infoLabel.text = R.string.localization.settingsFlowAutoblockScreenInfoTitle()
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Actions
    
    @objc
    func actionBack() {
        output.actionBack()
    }
}

extension AutoblockViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.autoblockTableViewCell.identifier,
                                                       for: indexPath) as? AutoblockTableViewCell else {
            return UITableViewCell()
        }
        let model = models[indexPath.row]
        cell.timeLabel.text = model.timeString
        cell.timeLabel.textColor = R.color.dark()

        if model.isSelected {
            cell.cellContentView.backgroundColor = R.color.gray1()?.withAlphaComponent(0.1)
            cell.clockImageView.isHidden = false
        } else {
            cell.cellContentView.backgroundColor = .clear
            cell.clockImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.actionSelectAutoblockTime(model: models[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

// MARK: - AutoblockViewInput

extension AutoblockViewController: AutoblockViewInput {
    func setupInitialState(models: [AutoblockModel]) {
        self.models = models
        tableView.reloadData()
  	}
}
