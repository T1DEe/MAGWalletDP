//
//  MainRoutingMainRoutingViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SafariServices
import SharedFilesModule
import SharedUIModule
import UIKit

class MainRoutingViewController: UIViewController {
    var output: MainRoutingViewOutput!
    @IBOutlet weak var flowLevelContainer: UIView!
    @IBOutlet weak var modalLevelContainer: UIView!
    @IBOutlet weak var frontLevelContainer: UIView!
    
    weak var flowNavigationController: UINavigationController?
    weak var modalRootViewController: UIViewController?
    weak var snackBarRoot: SnackBarRootModuleInput?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configRecognizer()
        configFlow()
        bindToApplicationState()
        bindToKeyboardEvents()
        output.viewIsReady()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Configuration
    
    fileprivate func configRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.delegate = self
        AppDelegate.currentWindow.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func bindToApplicationState() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    fileprivate func bindToKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionKeyboardTap),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionKeyboardTap),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    private func configFlow() {
        let navigation = BaseNavigationController()
        flowNavigationController = navigation
        addChild(child: navigation, container: flowLevelContainer)
        
        let modalContaner = UIViewController()
        modalContaner.view.backgroundColor = .clear
        modalRootViewController = modalContaner
        addChild(child: modalContaner, container: modalLevelContainer)
    }

    // MARK: Private
    private func addChild(child: UIViewController, container: UIView, toBack: Bool = true) {
        addChild(child)
        child.view.frame = CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height)
        container.addSubview(child.view)
        if toBack {
            container.sendSubviewToBack(child.view)
        }
        child.didMove(toParent: self)
    }
    
    private func wrapInViewControllerIfNeeded(controller: UIViewController) -> UIViewController {
        guard controller is UINavigationController == true else {
            return controller
        }
        let rootViewControler = UIViewController()
        rootViewControler.addChild(controller)
        controller.view.frame = CGRect(
            x: 0,
            y: 0,
            width: rootViewControler.view.frame.size.width,
            height: rootViewControler.view.frame.size.height
        )
        rootViewControler.view.addSubview(controller.view)
        controller.didMove(toParent: rootViewControler)
        return rootViewControler
    }

    private func clearPreviusChild(level: FlowUILevel) {
        let currentChild = level == .flow ? flowNavigationController : modalRootViewController
        if let controller = currentChild {
            controller.willMove(toParent: nil)
            controller.removeFromParent()
            controller.view.removeFromSuperview()
        }
    }

    private func removeChild(controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.removeFromParent()
        controller.view.removeFromSuperview()
    }

    private func showModalWithAnimation(
        modalViewController: UIViewController,
        container: UIView
        ) {
        // 1
        let modalView: UIView = modalViewController.view
        
        // 2
        let duration = 0.3
        
        // 3
        addChild(modalViewController)
        modalViewController.didMove(toParent: self)
        container.addSubview(modalView)
        
        // 4
        modalView.frame = CGRect(
            x: 0,
            y: modalView.frame.height,
            width: modalView.frame.width,
            height: modalView.frame.height
        )
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            modalView.frame = container.bounds
        }) { [weak self] _ in
            self?.modalRootViewController = modalViewController
        }
    }
    
    private func dismissModalWithAnimation(
        modalViewController: UIViewController,
        container: UIView
        ) {
        // 1
        let modalView: UIView = modalViewController.view
        
        // 2
        let duration = 0.3
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            modalView.frame = CGRect(
                x: 0,
                y: modalView.frame.height,
                width: modalView.frame.width,
                height: modalView.frame.height
            )
        }) { [weak self] _ in
            self?.removeChild(controller: modalViewController)
        }
    }
    
    private func setSelectedLevel(level: FlowUILevel) {
        switch level {
        case .flow:
            flowLevelContainer.isUserInteractionEnabled = true
            modalLevelContainer.isUserInteractionEnabled = false
            frontLevelContainer.isUserInteractionEnabled = false
            
        case .fronOfAll:
            flowLevelContainer.isUserInteractionEnabled = false
            modalLevelContainer.isUserInteractionEnabled = false
            frontLevelContainer.isUserInteractionEnabled = true
            
        case .modal:
            flowLevelContainer.isUserInteractionEnabled = false
            modalLevelContainer.isUserInteractionEnabled = true
            frontLevelContainer.isUserInteractionEnabled = false
        }
    }
    
    // MARK: – Actions
    
    @objc
    private func actionKeyboardTap() {
        output.didTouchScreen()
    }
    
    @objc
    private func actionDidBecomeActive() {
        output.actionDidBecomeActive()
    }
}

extension MainRoutingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        output.didTouchScreen()
        return false
    }
}

// MARK: - SFSafariViewControllerDelegate

extension MainRoutingViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismissFlow(animated: true, all: false)
    }
}

// MARK: - MainRoutingViewInput

extension MainRoutingViewController: MainRoutingViewInput {
    func setupInitialState() {
    }
    
    func setFlow(screen: UIViewController, animated: Bool, mode: MainRoutingViewMode) {
        if let safariVC = screen as? SFSafariViewController {
            safariVC.delegate = self
            safariVC.preferredBarTintColor = R.color.gray2()
            safariVC.preferredControlTintColor = R.color.gray1()
        }

        let wrappedScreen = wrapInViewControllerIfNeeded(controller: screen)
        switch mode {
        case .asRoot:
            flowNavigationController?.setViewControllers([wrappedScreen], animated: animated)
            
        case .push:
            flowNavigationController?.pushViewController(wrappedScreen, animated: animated)
            
        case .asRootExeptFirst:
            if let rootVC = flowNavigationController?.viewControllers.first {
                flowNavigationController?.setViewControllers([rootVC, wrappedScreen], animated: animated)
            } else {
                flowNavigationController?.setViewControllers([wrappedScreen], animated: animated)
            }
        }

        setSelectedLevel(level: .flow)
        if let snackBarRoot = snackBarRoot {
            presentSnackBarRoot(snackBarRoot)
        }
    }
    func dismissFlow(animated: Bool, all: Bool) {
        if all {
            flowNavigationController?.popToRootViewController(animated: animated)
        } else {
            flowNavigationController?.popViewController(animated: animated)
        }
    }

    func setModal(screen: UIViewController, animated: Bool) {
        if let presentedViewController = modalRootViewController?.presentedViewController {
            presentedViewController.dismiss(animated: false) { [weak self] in
                screen.modalPresentationStyle = .fullScreen
                self?.modalRootViewController?.present(screen, animated: animated, completion: nil)
            }
        } else {
            screen.modalPresentationStyle = .fullScreen
            modalRootViewController?.present(screen, animated: animated, completion: nil)
        }
        setSelectedLevel(level: .modal)
    }
    
    func dismissModal(animated: Bool) {
        modalRootViewController?.dismiss(animated: animated, completion: nil)
        setSelectedLevel(level: .flow)
    }
    
    func presentSnackBarRoot(_ snackBarRoot: SnackBarRootModuleInput) {
        self.snackBarRoot = snackBarRoot
        addChild(child: snackBarRoot.viewController, container: flowLevelContainer, toBack: false)
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarRoot?.presentSnackBar(snackBar: snackBar, animated: true)
    }
}
