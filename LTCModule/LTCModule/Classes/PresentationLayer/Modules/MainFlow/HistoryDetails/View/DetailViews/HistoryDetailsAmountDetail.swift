//
//  HistoryDetailsAmountDetail.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class HistoryDetailsAmountDetail: UIView {
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    
    // MARK: Public
    
    var title: String = String() {
        didSet {
            titleLabel.text = title
        }
    }
    
    var amount: NSAttributedString = NSAttributedString() {
        didSet {
            amountLabel.attributedText = amount
        }
    }
    
    var didGetValue: ((_ value: String) -> Void)?
    
    // MARK: Init
    
    init() {
        super.init(frame: CGRect.zero)
        config()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }

    // MARK: Config
    
    private func config() {
        configTitle()
        configAmount()
        configTap()
    }
    
    private func configTitle() {
        titleLabel.textColor = R.color.gray1()
        titleLabel.font = R.font.poppinsRegular(size: 14)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
        }
    }
    
    private func configAmount() {
        amountLabel.adjustsFontSizeToFitWidth = true
        addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        amountLabel.isUserInteractionEnabled = true
        amountLabel.addGestureRecognizer(tap)
    }

    @objc
    private func tapAction() {
        didGetValue?(amount.string)
    }
}
