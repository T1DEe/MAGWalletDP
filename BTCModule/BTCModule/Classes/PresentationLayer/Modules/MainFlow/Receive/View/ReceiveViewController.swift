//
//  ReceiveReceiveViewController.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class ReceiveViewController: UIViewController {
    var output: ReceiveViewOutput!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accountNameView: UIView!
    @IBOutlet weak var accountInfoLabel: UILabel!
    @IBOutlet weak var copyButton: ImageButton!
    @IBOutlet weak var qrcodeImage: UIImageView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: Config
    
    private func config() {
        configBackground()
        configColors()
        configFonts()
        configLocalization()
        configButton()
        configAccountInfo()
    }
    
    private func configButton() {
        backButton.image = R.image.backIcon()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
        
        copyButton.image = R.image.copy()
        copyButton.touchUpInside = { [weak self] _ in
            self?.actionCopy()
        }
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.receiveFlowTitle()
    }
    
    private func configBackground() {
        view.backgroundColor = R.color.light()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsRegular(size: 22)
        accountInfoLabel.font = R.font.poppinsMedium(size: 14)
    }
    
    private func configColors() {
        titleLabel.textColor = R.color.dark()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
        accountInfoLabel.textColor = R.color.blue()
    }
    
    private func configAccountInfo() {
        accountNameView.layer.cornerRadius = 4
        accountNameView.layer.borderColor = R.color.gray2()?.cgColor
        accountNameView.layer.borderWidth = 1
        accountNameView.backgroundColor = R.color.gray2()?.withAlphaComponent(0.3)
    }
    
    // MARK: Actions
    
    private func actionCopy() {
        output.actionCopy(text: accountInfoLabel.text ?? "")
    }
}

// MARK: - ReceiveViewInput

extension ReceiveViewController: ReceiveViewInput {
    func setupState(entity: ReceiveEntity) {
        accountInfoLabel.text = entity.address
      }
    
    func setupQRCodeImage(image: UIImage) {
        qrcodeImage.alpha = 0
        qrcodeImage.image = image
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.qrcodeImage.alpha = 1
        }
    }
    
    func getqrCodeImageViewSize() -> CGSize {
        return qrcodeImage.frame.size
    }
}
