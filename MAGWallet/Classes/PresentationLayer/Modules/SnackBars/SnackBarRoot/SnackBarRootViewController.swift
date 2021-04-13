//
//  SnackBarRootSnackBarRootViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class SnackBarRootViewController: UIViewController {
    var output: SnackBarRootViewOutput!
    var snackBar: SnackBarRootModel?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var snackBarView: SnackBarTouchableView!
    @IBOutlet weak var snackBarContainerView: UIView!
    @IBOutlet weak var snackBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var snackBarBottomConstraint: NSLayoutConstraint!
    
    fileprivate let animationDuration = 0.3
    fileprivate let snackBarViewBottomOffset: CGFloat = 8
    fileprivate let snackBarViewCornerRadius: CGFloat = 12
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToKeyboard()
        output.viewIsReady()
        snackBarView.canTapOnView = { [weak self] view in
            guard let self = self else {
                return false
            }
            if self.snackBar?.snackBarPresentableModel.isFullScreen == true ||
                view?.isDescendant(of: self.snackBarContainerView) == true {
                return true
            }
            return false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: – Config
    
    fileprivate func config() {
        configGesture()
    }
    
    fileprivate func configGesture() {
        removeAllGestures()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    fileprivate func removeAllGestures() {
        guard let gestureRecognizers = view.gestureRecognizers else {
            return
        }
        
        for gesture in gestureRecognizers {
            view.removeGestureRecognizer(gesture)
        }
    }
    
    fileprivate func bindToKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: – Actions
    
    @objc
    fileprivate func actionTap() {
        output.actionOnEmptyPlaceTap()
    }
    
    @objc
    func actionSwipeDown() {
        output.actionSwipeDown()
    }
    
    @objc
    func actionOnSnackBarTap() {
        output.actionSwipeDown()
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let snackBar = snackBar else {
            return
        }
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        snackBarBottomConstraint.constant = snackBarViewBottomOffset + snackBar.snackBarView.frame.height + keyboardHeight
        UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            if self?.snackBar == nil {
                self?.snackBarBottomConstraint.constant = -(self?.snackBarViewBottomOffset ?? 0) // to prevent disabled area without popup
            }
        }
    }
    
    @objc
    func keyboardHide(notification: Notification) {
        if let snackBar = snackBar {
            snackBarBottomConstraint.constant = snackBarViewBottomOffset + snackBar.snackBarView.frame.height
        } else {
            snackBarBottomConstraint.constant = -snackBarViewBottomOffset
        }
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutSubviews()
        }
    }
    
    // MARK: – Private
    
    fileprivate func addChild(snackBar: SnackBarRootModel, container: UIView) {
        addChild(snackBar.snackBarViewController)
        self.snackBar = snackBar
        snackBarContainerView.subviews.forEach { $0.removeFromSuperview() }
        snackBarContainerView.addSubview(snackBar.snackBarPresentableModel.snackBarView)
        snackBar.snackBarPresentableModel.snackBarView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        UIView.performWithoutAnimation {
            self.snackBarContainerView.layoutIfNeeded()
            let height = snackBar.snackBarPresentableModel.snackBarView.frame.height
            self.snackBarHeightConstraint.constant = height
            self.snackBarContainerView.layoutIfNeeded()
        }
        snackBar.snackBarViewController.didMove(toParent: self)
        
        if snackBar.snackBarPresentableModel.isFullScreen == true {
            config()
            setupFullScreenState(snackBar: snackBar)
        } else {
            setupNonFullScreenState(snackBar: snackBar)
        }
    }
    
    fileprivate func addShadowAndCorners(snackBar: SnackBarRootModel) {
        snackBarContainerView.layer.cornerRadius = snackBarViewCornerRadius
        snackBar.snackBarView.layer.cornerRadius = snackBarViewCornerRadius
        snackBarContainerView.clipsToBounds = true
        snackBar.snackBarView.clipsToBounds = true
    }
    
    fileprivate func addSwipeAndTapGestureOnSnackBar(snackBar: SnackBarRootModel) {
        guard snackBar.snackBarPresentableModel.isFullScreen == false else {
            return
        }
        guard snackBar.snackBarPresentableModel.needAddSwipeForClose == true else {
            return
        }
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipeDown))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionOnSnackBarTap))
        swipeGesture.direction = .down
        swipeGesture.cancelsTouchesInView = false
        snackBar.snackBarView.addGestureRecognizer(swipeGesture)
        snackBar.snackBarView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: – Fullscreen
    
    fileprivate func setupFullScreenState(snackBar: SnackBarRootModel) {
        if snackBar.shouldShowAnimated == true {
            setupAnimatedFullSreenState(snackBar: snackBar)
        } else {
            setupFullScreenStateWithAnimatedAlpha(snackBar: snackBar)
        }
        addShadowAndCorners(snackBar: snackBar)
    }
    
    fileprivate func setupAnimatedFullSreenState(snackBar: SnackBarRootModel) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.backgroundView.backgroundColor = R.color.dark()?.withAlphaComponent(0.2)
        }) { _ in
            UIView.animate(withDuration: self.animationDuration) {
                self.snackBarBottomConstraint.constant = self.snackBarViewBottomOffset + snackBar.snackBarView.frame.height
                self.view.layoutSubviews()
            }
        }
    }
    
    fileprivate func setupFullScreenStateWithAnimatedAlpha(snackBar: SnackBarRootModel) {
        self.backgroundView.backgroundColor = R.color.dark()?.withAlphaComponent(0.2)
        self.snackBarBottomConstraint.constant = snackBarViewBottomOffset + snackBar.snackBarView.frame.height
        self.view.layoutSubviews()
    }
    
    // MARK: – Not fullscreen
    
    fileprivate func setupNonFullScreenState(snackBar: SnackBarRootModel) {
        if snackBar.shouldShowAnimated == true {
            setupAnimatedNonFullScreenState(snackBar: snackBar)
        } else {
            setupNonAnimatedNonFullScreenState(snackBar: snackBar)
        }
        
        addShadowAndCorners(snackBar: snackBar)
    }
    
    fileprivate func setupAnimatedNonFullScreenState(snackBar: SnackBarRootModel) {
        self.view.setNeedsLayout()
        self.view.layoutSubviews()
        self.snackBarBottomConstraint.constant = self.snackBarViewBottomOffset + snackBar.snackBarView.frame.height
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutSubviews()
        }
    }
    
    fileprivate func setupNonAnimatedNonFullScreenState(snackBar: SnackBarRootModel) {
        snackBarBottomConstraint.constant = snackBarViewBottomOffset + snackBar.snackBarView.frame.height
        self.view.layoutSubviews()
    }
    
    // MARK: – Dismiss
    
    fileprivate func removeFullScreenState(snackBar: SnackBarRootModel) {
        snackBar.snackBarViewController.removeFromParent()
        snackBar.snackBarViewController.didMove(toParent: nil)
        UIView.animate(withDuration: animationDuration, animations: {
            self.snackBarBottomConstraint.constant = -snackBar.snackBarPresentableModel.snackBarView.frame.height - self.snackBarViewBottomOffset
            self.view.layoutSubviews()
        }) { _ in
            UIView.animate(withDuration: self.animationDuration, animations: {
                self.backgroundView.backgroundColor = .clear
            }) { _ in
                snackBar.snackBarPresentableModel.snackBarView.removeFromSuperview()
                if snackBar === self.snackBar {
                    self.snackBar = nil
                    self.output.didRemoveSnackBarView()
                }
            }
        }
    }
    
    fileprivate func removeNonFullScreenState(snackBar: SnackBarRootModel) {
        snackBar.snackBarViewController.removeFromParent()
        snackBar.snackBarViewController.didMove(toParent: nil)
        UIView.animate(withDuration: animationDuration, animations: {
            self.snackBarBottomConstraint.constant = -snackBar.snackBarPresentableModel.snackBarView.frame.height - self.snackBarViewBottomOffset
            self.view.layoutSubviews()
        }) { _ in
            snackBar.snackBarPresentableModel.snackBarView.removeFromSuperview()
            if snackBar === self.snackBar {
                self.snackBar = nil
                self.output.didRemoveSnackBarView()
            }
        }
    }
}

extension SnackBarRootViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: snackBarContainerView) == true {
            return false
        }
        
        return true
    }
}

// MARK: - SnackBarRootViewInput

extension SnackBarRootViewController: SnackBarRootViewInput {
    func setupInitialState(snackBar: SnackBarRootModel) {
        addChild(snackBar: snackBar, container: snackBarContainerView)
        addSwipeAndTapGestureOnSnackBar(snackBar: snackBar)
  	}

    func removeSnackBarView(snackBar: SnackBarRootModel) {
        if snackBar.snackBarPresentableModel.isFullScreen == true {
            removeFullScreenState(snackBar: snackBar)
        } else {
            removeNonFullScreenState(snackBar: snackBar)
        }
    }
}
