//
//  HistoryDetailsTextDetail.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class HistoryDetailsTextDetail: UIView {
    private let titleLabel = UILabel()
    private let container = UIView()
    private let valueLabel = UILabel()
    
    // MARK: Public
    
    var title: String = String() {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: String = String() {
        didSet {
            valueLabel.text = value
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
        configContainer()
        configValue()
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
    
    private func configContainer() {
        container.backgroundColor = R.color.gray2()?.withAlphaComponent(0.3)
        container.layer.borderColor = R.color.gray2()?.cgColor
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 4
        container.layer.masksToBounds = true
        addSubview(container)
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp_bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configValue() {
        valueLabel.textColor = R.color.blue()
        valueLabel.font = R.font.poppinsMedium(size: 14)
        valueLabel.numberOfLines = 0
        container.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    private func configTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        valueLabel.isUserInteractionEnabled = true
        valueLabel.addGestureRecognizer(tap)
    }

    @objc
    private func tapAction() {
        didGetValue?(value)
    }
}
