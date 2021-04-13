//
//  SettingsSettingsViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class SettingsViewController: UIViewController {
    var output: SettingsViewOutput!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var buttons = [SidebarScreenButton]()
    let rowHeight = 62
    let scrollTopInset: CGFloat = 40
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Config
    
    private func config() {
        configObserver()
        configBackground()
        configColors()
        configFonts()
        configLocalization()
        configButton()
        configGradientView()
        configScrollView()
    }
    
    private func configBackground() {
        view.backgroundColor = R.color.light()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsRegular(size: 22)
    }
    
    private func configColors() {
        titleLabel.textColor = R.color.dark()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
    }
    
    private func configButton() {
        backButton.image = R.image.cancel()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.settingsFlowTitle()
    }
    
    private func configButtons(model: SettingsEntity) {
        for view in buttonsContainer.subviews {
            view.removeFromSuperview()
        }
        
        for index in 0..<model.elements.count {
            configButton(index: index, elements: model.elements)
        }
    }
    
    private func configButton(index: Int, elements: [SettingsElementType]) {
        let element = elements[index]
        
        let button = SidebarScreenButton()
        button.isExclusiveTouch = true
        button.title = getTitleForElement(element)
        button.image = getIconForElement(element)
        
        switch element {
        case .touchId(let isOn), .faceId(let isOn):
            button.indicator.isHidden = true
            button.rightSwitch.isHidden = false
            button.rightSwitch.isOn = isOn
            
            button.actionSwitchHandler = { [weak self] value in
                self?.output.actionBiometricToggled(value)
            }
            
        case .notifications(let isOn):
            button.indicator.isHidden = true
            button.rightSwitch.isHidden = false
            button.rightSwitch.isOn = isOn
            
            button.actionSwitchHandler = { [weak self] value in
                self?.output.actionNotificationsToggled(value)
            }
            
        default:
            break
        }
        
        buttonsContainer.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(index * rowHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(rowHeight)
            if index == elements.count - 1 {
                make.bottom.equalToSuperview()
            }
        }
        
        button.actionSelected = { [weak self] button in
            self?.disableAllExept(button: button)
        }
        
        button.actionTouchInside = { [weak self] in
            self?.output.actionElementSelected(element)
        }
        
        button.actionDeselected = { [weak self] _ in
            self?.enableAll()
        }
        
        buttons.append(button)
    }
    
    private func configGradientView() {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.locations = [0, 0.5, 1]
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(1.0).cgColor
        ]
        gradient.frame = gradientView.bounds
        gradientView.layer.mask = gradient
    }
    
    private func configScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: scrollTopInset, left: 0, bottom: 0, right: 0)
    }
    
    private func configObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil
        )
    }
    
    private func disableAllExept(button: SidebarScreenButton) {
        buttons.forEach {
            if $0 != button {
                $0.isUserInteractionEnabled = false
            }
        }
    }
    
    private func enableAll() {
        buttons.forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func updateScrollView() {
        scrollView.layoutIfNeeded()
        scrollView.delaysContentTouches = scrollView.contentSize.height > scrollView.frame.height
    }
    
    // MARK: Private
    
    private func getIconForElement(_ element: SettingsElementType) -> UIImage? {
        switch element {
        case .changePin:
            return R.image.change_pin()
            
        case .autoblock:
            return R.image.autoblock()
        
        case .changeNetwork:
            return R.image.changeNetwork()
            
        case .multiAccounts:
            return R.image.accounts()
            
        case .logout:
            return R.image.logout()
            
        case .touchId:
            return R.image.touchIdIcon()
            
        case .faceId:
            return R.image.faceIdIcon()
            
        case .notifications:
            // TODO: Change Icon
            return R.image.changeNetwork()
        }
    }
    
    private func getTitleForElement(_ element: SettingsElementType) -> String? {
        switch element {
        case .changePin:
            return R.string.localization.settingsFlowChangePin()
            
        case .autoblock:
            return R.string.localization.settingsFlowAutoblock()

        case .changeNetwork:
            return R.string.localization.settingsFlowChangeNetwork()
            
        case .multiAccounts:
            return R.string.localization.settingsFlowMultiaccountsScreenTitle()
        
        case .logout:
            return R.string.localization.settingsFlowLogout()
            
        case .touchId:
            return R.string.localization.settingsFlowTouchId()
            
        case .faceId:
            return R.string.localization.settingsFlowFaceId()
            
        case .notifications:
            return R.string.localization.settingsFlowNotifications()
        }
    }
    
    @objc
    func willEnterForeground() {
        output.actionCheckNotificationsDenied()
    }
}

// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    func setupInitialState(model: SettingsEntity) {
        configButtons(model: model)
    }
    
    func setVersion(version: String) {
        versionLabel.text = version
    }
}
