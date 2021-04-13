//
//  SidebarScreenButton.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SnapKit
import UIKit

class SidebarScreenButton: UIView {
    var isSelected: Bool = false {
        didSet {
            configStateBySelected()
        }
    }
    
    var indicator: UIImageView!
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var actionSelected: ((SidebarScreenButton) -> Void)?
    var actionDeselected: ((SidebarScreenButton) -> Void)?
    var actionTouchInside: (() -> Void)?
    var actionSwitchHandler: ((Bool) -> Void)?

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let actionButton = UIButton()
    let rightSwitch = UISwitch()
    
    private let selectedColor = R.color.purple()?.withAlphaComponent(0.1)
    private let deselectedColor = UIColor.clear
    
    init() {
        super.init(frame: CGRect.zero)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    // MARK: Config
    
    private func config() {
        configIcon()
        configTitle()
        configButton()
        configIconIndicatorIfNeeded()
        configStateBySelected()
        configSwitch()
    }
    
    private func configIcon() {
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor.clear
        
        addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        
        iconContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(22)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configTitle() {
        titleLabel.font = R.font.poppinsMedium(size: 17)
        titleLabel.textColor = R.color.dark()
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(54)
        }
    }
    
    private func configIconIndicatorIfNeeded() {
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor.clear
        
        addSubview(iconContainer)
        let imageView = UIImageView()
        imageView.image = R.image.cell_arrow()
        iconContainer.addSubview(imageView)

        iconContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(12)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        indicator = imageView
    }
    
    private func configButton() {
        addSubview(actionButton)
        actionButton.isExclusiveTouch = true
        actionButton.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        actionButton.addTarget(self, action: #selector(actionTouchUpInside), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionTouchDown), for: .touchDown)
        actionButton.addTarget(self, action: #selector(actionTouchCancel), for: .touchCancel)
        actionButton.addTarget(self, action: #selector(actionTouchUpOutside), for: .touchUpOutside)
    }
    
    private func configStateBySelected() {
        let color = isSelected ? selectedColor : deselectedColor
        backgroundColor = color
    }
    
    private func configSwitch() {
        addSubview(rightSwitch)
        rightSwitch.isHidden = true
        rightSwitch.onTintColor = R.color.purple()
        rightSwitch.addTarget(self, action: #selector(actionSwitchChanged), for: .valueChanged)
        
        rightSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
    }
    
    // MARK: Actions
    
    @objc
    private func actionTouchUpInside() {
        actionTouchInside?()
        actionDeselected?(self)
        backgroundColor = deselectedColor
    }
    
    @objc
    private func actionTouchDown() {
        actionSelected?(self)
        backgroundColor = selectedColor
    }
    
    @objc
    private func actionTouchUpOutside() {
        actionDeselected?(self)
        backgroundColor = deselectedColor
    }
    
    @objc
    private func actionTouchCancel() {
        actionDeselected?(self)
        backgroundColor = deselectedColor
    }
    
    @objc
    private func actionSwitchChanged() {
        actionSwitchHandler?(rightSwitch.isOn)
    }
}
