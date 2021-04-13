//
//  ApplySnackBarViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ApplySnackBarViewController: UIViewController {
    var output: ApplySnackBarViewOutput!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        output.viewIsReady()
    }
    
    // MARK: Config
    
    fileprivate func config() {
        configBackgroundImageView()
        configLocalization()
        configSwipe()
    }
    
    fileprivate func configBackgroundImageView() {
        backgroundImageView.tintColor = UIColor.black.withAlphaComponent(0.04)
    }
    
    fileprivate func configLocalization() {
        titleLabel.text = "titleLabel"//R.string.localization.snackBarAppySendDataTitle()
    }
    
    fileprivate func configSwipe() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipeDown))
        swipeGesture.direction = .down
        swipeGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: Actions
    
    @IBAction func actionApply(_ sender: Any) {
        output.actionApply()
    }
    
    @IBAction func actionDeny(_ sender: Any) {
        output.acitonDeny()
    }
    
    @objc
    func actionSwipeDown() {
        output.acitonDeny()
    }
}

// MARK: - ApplySnackBarViewInput

extension ApplySnackBarViewController: ApplySnackBarViewInput {
    func setupInitialState(model: ApplySnackBarModel) {
        let amount = model.amount
        
        var subtitle = String()
        
        let accountString = "accountString"//R.string.localization.snackBarAppySendDataAccount(account)
        subtitle.append(accountString)
        
        if let amount = amount, !amount.isEmpty {
            let amountString = "amountString"//R.string.localization.snackBarAppySendDataAmount(amount)
            subtitle.append(amountString)
        }
        
        let currencyString = "currencyString"//R.string.localization.snackBarAppySendDataCurrency(currency.name)
        subtitle.append(currencyString)
        
        subtitleLabel.text = subtitle
    }
}
