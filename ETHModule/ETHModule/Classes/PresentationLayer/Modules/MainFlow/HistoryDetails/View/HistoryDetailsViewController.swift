//
//  HistoryDetailsViewController.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class HistoryDetailsViewController: UIViewController {
    var output: HistoryDetailsViewOutput!

    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var explorerHeaderButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var confirmationImageView: UIImageView!
    @IBOutlet weak var detailsWhiteBackground: UIView!
    @IBOutlet weak var detailsContainer: UIView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var detailsBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    private let gradientHeight: CGFloat = 20
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateBackgroundHeight()
    }

    // MARK: - Config
    
    private func config() {
        configColors()
        configFonts()
        configDetailsWhiteBackground()
        configButtons()
        configScrollView()
        configTopGradientView()
        configBottomGradientView()
    }
    
    private func configColors() {
        view.backgroundColor = R.color.gray2()
        detailsWhiteBackground.backgroundColor = R.color.light()
        
        titleLabel.textColor = R.color.dark()
        amountLabel.textColor = R.color.dark()
        dateLabel.textColor = R.color.dark()?.withAlphaComponent(0.5)
        confirmationLabel.textColor = R.color.dark()
        explorerHeaderButton.setTitleColor(R.color.gray1(), for: .normal)
        
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsRegular(size: 22)
        amountLabel.font = R.font.poppinsMedium(size: 22)
        dateLabel.font = R.font.poppinsMedium(size: 14)
        confirmationLabel.font = R.font.poppinsMedium(size: 16)
        explorerHeaderButton.titleLabel?.font = R.font.poppinsRegular(size: 14)
    }
    
    private func configDetailsWhiteBackground() {
        detailsWhiteBackground.layer.cornerRadius = 8
        detailsWhiteBackground.layer.masksToBounds = true
    }
    
    private func configButtons() {
        backButton.image = R.image.backIcon()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
        explorerHeaderButton.setTitle(R.string.localization.historyDetailsExplorerButton(), for: .normal)
    }

    private func configScrollView() {
        scrollView.delegate = self
    }

    private func configTopGradientView() {
        topGradientView.layer.cornerRadius = 8
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
        bottomGradientView.layer.cornerRadius = 8
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.colors = [
                           UIColor.white.withAlphaComponent(0.0).cgColor,
                           UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = bottomGradientView.bounds
        bottomGradientView.layer.mask = gradient
        bottomGradientView.alpha = 0
    }

    private func calculateBackgroundHeight() {
        var maxBackgroundHeight = self.view.frame.height - detailsWhiteBackground.frame.origin.y
        var bottomOffset: CGFloat = 16
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom, bottomPadding > 0 {
                bottomOffset = bottomPadding
            }
        }
        maxBackgroundHeight -= bottomOffset

        let height = scrollView.contentSize.height
        if height <= maxBackgroundHeight {
            detailsBackgroundHeightConstraint.constant = height
        } else {
            detailsBackgroundHeightConstraint.constant = maxBackgroundHeight
            bottomGradientView.alpha = 1.0
        }
    }
    
    private func configMainInfo(_ model: HistoryDetailsScreenModel) {
        titleLabel.text = R.string.localization.historyDetailsTitle()
        amountLabel.attributedText = model.amount
        dateLabel.text = model.date
        
        let confirmedText = R.string.localization.historyDetailsConfirmed()
        let confirmationText = R.string.localization.historyDetailsConfirmation()
        let confirmedImage = R.image.confirmedIcon()
        let confirmationImage = R.image.confirmationIcon()
        
        confirmationImageView.image = model.isConfirmed ? confirmedImage : confirmationImage
        confirmationLabel.text = model.isConfirmed ? confirmedText : confirmationText
    }
    
    private func configDetails(_ model: HistoryDetailsScreenModel) {
        detailsContainer.subviews.forEach { $0.removeFromSuperview() }
        
        var lastView: UIView?
        for index in 0..<model.details.count {
            let detail = model.details[index]
            var detailView: UIView? = nil
            if let amountDetail = detail as? HistoryDetailsAmountDetailScreenModel {
                let view = HistoryDetailsAmountDetail()
                view.amount = amountDetail.amountValue
                view.title = amountDetail.title
                detailView = view
            }
            
            if let textDetail = detail as? HistoryDetailsTextDetailScreenModel {
                let view = HistoryDetailsTextDetail()
                view.value = textDetail.value
                view.title = textDetail.title
                view.didGetValue = { [weak self] value in
                    self?.output.actionOpenInExplorerFromValue(value: value)
                }
                detailView = view
            }
            
            guard let view = detailView else {
                print("Unknown history details type")
                continue
            }
            
            detailsContainer.addSubview(view)
            
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                if index == 0 {
                    make.top.equalToSuperview().offset(18)
                } else if let lastView = lastView {
                    make.top.equalTo(lastView.snp_bottom).offset(18)
                }
                
                if index == model.details.count - 1 {
                    let offset = -18 - view.safeAreaInsets.bottom
                    make.bottom.equalToSuperview().offset(offset)
                }
            }
            
            lastView = view
        }
        view.layoutIfNeeded()
    }

    // MARK: - Actions

    @IBAction func actionOpenInExplorerFromHeader(_ sender: Any) {
        output.actionOpenInExplorerFromHeader()
    }
}

// MARK: - UIScrollViewDelegate

extension HistoryDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomOffset = scrollView.contentOffset.y + scrollView.frame.height
        let diff = scrollView.contentSize.height - bottomOffset
    
        topGradientView.alpha = scrollView.contentOffset.y / gradientHeight
        bottomGradientView.alpha = diff / gradientHeight
    }
}

// MARK: - HistoryDetailsViewInput

extension HistoryDetailsViewController: HistoryDetailsViewInput {
    func setupInitialState(_ model: HistoryDetailsScreenModel) {
        configMainInfo(model)
        configDetails(model)
  	}
}
