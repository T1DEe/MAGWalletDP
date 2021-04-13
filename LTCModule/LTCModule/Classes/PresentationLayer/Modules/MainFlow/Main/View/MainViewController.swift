//
//  MainMainViewController.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import SnapKit
import UIKit

class MainViewController: UIViewController {
    var output: MainViewOutput!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var sendButton: TextButton!
    @IBOutlet weak var receiveButton: TextButton!
    var previusHeightConstraint: CGFloat = 0
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerHeightConstraint: NSLayoutConstraint!
    let topContainerRange = (CGFloat(ContainerOffsetsConstant.topOffset)..<CGFloat(ContainerOffsetsConstant.boottomOffset))
    var displayLinker: DisplayUpdateNotifier!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: Configuration
    
    private func config() {
        configBackground()
        configFonts()
        configActions()
        configColors()
        configLocalization()
        configDisplayUpdater()
    }
    
    private func configDisplayUpdater() {
        displayLinker = DisplayUpdateNotifier(listener: self)
    }
    
    private func configBackground() {
        view.backgroundColor = R.color.light()
    }
    
    private func configFonts() {
        sendButton.titleFont = R.font.poppinsRegular(size: 17)
        receiveButton.titleFont = R.font.poppinsRegular(size: 17)
    }
    
    private func configColors() {
        sendButton.style = .main
        sendButton.colorBackground = R.color.purple()
        sendButton.colorAdditionalBackground = R.color.light()
        sendButton.colorTitle = R.color.light()
        
        receiveButton.style = .additional
        receiveButton.colorBackground = R.color.blue()
        receiveButton.colorAdditionalBackground = R.color.light()
        receiveButton.colorTitle = R.color.light()
    }
    
    private func configActions() {
        receiveButton.touchUpInside = { [weak self] _ in
            self?.output.actionReceive()
        }
        
        sendButton.touchUpInside = { [weak self] _ in
            self?.output.actionSend()
        }
    }
    
    private func configLocalization() {
        receiveButton.title = R.string.localization.mainFlowReceiveButton()
        sendButton.title = R.string.localization.mainFlowSendButton()
    }
    
    // MARK: Actions
    
    // MARK: Private
    private func addChild(child: UIViewController, container: UIView) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(child.view)
        addChild(child)
        child.view.snp_makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        child.didMove(toParent: self)
    }
}

extension MainViewController: DisplayUpdateReceiver {
    func displayWillUpdate(deltaTime: CFTimeInterval) {
        let offset = topContainerHeightConstraint.constant
        let step: CGFloat = 10
        let isScrollingBottom = previusHeightConstraint <= topContainerHeightConstraint.constant
        let newTopConstraint: CGFloat
        if offset <= topContainerRange.lowerBound {
            newTopConstraint = topContainerRange.lowerBound
            displayLinker.stopDisplayLink()
        } else if offset >= topContainerRange.upperBound {
            newTopConstraint = topContainerRange.upperBound
            displayLinker.stopDisplayLink()
        } else if isScrollingBottom {
            newTopConstraint = topContainerHeightConstraint.constant + step
        } else {
            newTopConstraint = topContainerHeightConstraint.constant - step
        }
        
        previusHeightConstraint = topContainerHeightConstraint.constant
        topContainerHeightConstraint.constant = newTopConstraint
        output.topContainerHeightChanged(height: topContainerHeightConstraint.constant)
    }
}

// MARK: - MainViewInput

extension MainViewController: MainViewInput {
    func setupInitialState(root: MainRootType) {
        addChild(child: root.wallet, container: topContainer)
        addChild(child: root.history, container: bottomContainer)
    }
    
    func setupScrollOffset(offset: CGFloat) {
        displayLinker.stopDisplayLink()
        
        var containerHeight: CGFloat = 0
        
        if offset > topContainerRange.upperBound {
            containerHeight = topContainerRange.upperBound
        } else if offset < topContainerRange.lowerBound {
            containerHeight = topContainerRange.lowerBound
        } else {
            containerHeight = offset
        }
        
        previusHeightConstraint = topContainerHeightConstraint.constant
        topContainerHeightConstraint.constant = containerHeight
        output.topContainerHeightChanged(height: containerHeight)
    }
    
    func setupAutoScroll() {
        displayLinker.startDisplayLink()
    }
}
