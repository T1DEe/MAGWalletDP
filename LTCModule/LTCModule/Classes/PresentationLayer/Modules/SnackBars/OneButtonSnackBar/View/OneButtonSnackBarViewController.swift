//
//  OneButtonSnackBarOneButtonSnackBarViewController.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class OneButtonSnackBarViewController: UIViewController {
    var output: OneButtonSnackBarViewOutput!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: TextButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    
    private let lableLeadingConstant: CGFloat = 32
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        output.viewIsReady()
    }
    
    // MARK: - Config
    
    private func config() {
        confgiColors()
        configFonts()
        configActions()
    }
    
    private func confgiColors() {
        containerView.backgroundColor = R.color.purple()
        titleLabel.textColor = R.color.light()
        
        button.style = .popup
        button.colorBackground = R.color.light()
        button.colorAdditionalBackground = R.color.light()
        button.colorTitle = R.color.light()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsMedium(size: 17)
        button.titleFont = R.font.poppinsRegular(size: 17)
    }
    
    private func configActions() {
        button.touchUpInside = { [weak self] _ in
            self?.output.actionButtonClick()
        }
    }
}

// MARK: - OneButtonSnackBarViewInput

extension OneButtonSnackBarViewController: OneButtonSnackBarViewInput {
    func setupInitialState(model: OneButtonSnackBarModel) {
        titleLabel.text = model.title
        button.title = model.buttonTitle
        if model.isError == false {
            iconImage.isHidden = true
            labelLeading.constant = lableLeadingConstant
            view.layoutIfNeeded()
        }
      }
}
