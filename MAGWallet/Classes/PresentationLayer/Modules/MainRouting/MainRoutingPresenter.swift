//
//  MainRoutingMainRoutingPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SafariServices
import SharedFilesModule
import SharedUIModule
import UIKit

enum SessionState {
    case notExpired
    case expired
}

class MainRoutingPresenter {
    weak var view: MainRoutingViewInput!
    weak var output: MainRoutingModuleOutput?
    var sessionState: SessionState = .notExpired

    var interactor: MainRoutingInteractorInput!
    var router: MainRoutingRouterInput!

    var modularFlows = [ModularSubflow]()
    var isMultiWalletMode = false
    var currentFlow: ModularSubflow?

    func presentInitialState() {
        if modularFlows.count == 1, let currentFlow = modularFlows.first {
            isMultiWalletMode = false
            setChoosenFlow(flow: currentFlow)
        } else {
            isMultiWalletMode = true
            let allCurrencies = router.getAllCurrencies(output: self, accounts: modularFlows, networks: modularFlows)
            showScreen(allCurrencies.viewController, flowType: .main(needShowBack: false), animated: false, mode: .asRoot)
        }
    }
    
    func setupFlowsCallbacks() {
        modularFlows.forEach {
            $0.didEndFlow = { [weak self] flow, reason in
                self?.didEndFlow(flow: flow, reason: reason)
            }
            $0.didSelectFlow = { [weak self] flow in
                self?.didSelectFlow(flow: flow)
            }
        }
    }
    
    func didRequestChangePin() {
        let change = router.getChangePinModule(output: self)
        view.setModal(screen: change.viewController, animated: true)
    }

    func didShowExplorer(url: URL) {
        let safari = router.getSafariVC(url: url)
        view.setFlow(screen: safari, animated: true, mode: .push)
    }
    
    func showScreen(_ viewConroller: UIViewController, flowType: FlowType, animated: Bool, mode: MainRoutingViewMode) {
        switch flowType {
        case .auth:
            interactor.stopExpirationMonitoring()
            
        default:
            interactor.startExpirationMonitoring()
        }
        view.setFlow(screen: viewConroller, animated: animated, mode: mode)
    }
    
    func didSelectFlow(flow: FlowType) {
        guard let currentFlow = currentFlow else {
            return
        }
        let screen = currentFlow.getFlow(type: flow).viewController
        showScreen(screen, flowType: flow, animated: true, mode: .push)
    }

    func didEndFlow(flow: FlowType, reason: FlowEndReason) {
        switch flow {
        case .auth:
            presentNextFlowAfterAuth(reason: reason)
            
        case .settings:
            presentNextFlowAfterSettings(reason: reason)
            
        case .send:
            presentNextFlowAfterSend(reason: reason)
            
        case .main:
            presentNextFlowAfterMain(reason: reason)
        }
    }
    
    private func setChoosenFlow(flow: ModularSubflow) {
        currentFlow = flow
        let type: FlowType
        if flow.hasAccounts() {
            type = .main(needShowBack: isMultiWalletMode)
        } else {
            type = .auth(needShowBack: isMultiWalletMode)
        }
        let mode: MainRoutingViewMode = isMultiWalletMode ? .asRootExeptFirst : .asRoot
        let screen = flow.getFlow(type: type).viewController
        let animated = isMultiWalletMode ? true : false

        showScreen(screen, flowType: type, animated: animated, mode: mode)
    }
    
    private func presentNextFlowAfterSettings(reason: FlowEndReason) {
        guard let currentFlow = currentFlow else {
            return
        }
        switch reason {
        case .needAuth:
            let flowType = FlowType.auth(needShowBack: isMultiWalletMode)
            let screen = currentFlow.getFlow(type: flowType).viewController
            let mode: MainRoutingViewMode = isMultiWalletMode ? .asRootExeptFirst : .asRoot
            showScreen(screen, flowType: flowType, animated: true, mode: mode)
            
        default:
            view.dismissFlow(animated: true, all: false)
        }
    }
    
    private func presentNextFlowAfterSend(reason: FlowEndReason) {
        guard let _ = currentFlow else {
            return
        }
        view.dismissFlow(animated: true, all: false)
    }
    
    private func presentNextFlowAfterMain(reason: FlowEndReason) {
        guard let _ = currentFlow else {
            return
        }
        
        view.dismissFlow(animated: true, all: false)
    }
    
    private func presentNextFlowAfterAuth(reason: FlowEndReason) {
        switch reason {
        case .completed:
            if let currentFlow = currentFlow {
                let flowType = FlowType.main(needShowBack: isMultiWalletMode)
                let screen = currentFlow.getFlow(type: flowType).viewController
                let mode: MainRoutingViewMode = isMultiWalletMode ? .asRootExeptFirst : .asRoot
                showScreen(screen, flowType: flowType, animated: true, mode: mode)
            } else {
                presentInitialState()
            }
            
        case .canceled(let needHide):
            if needHide {
                view.dismissFlow(animated: true, all: false)
            }
            interactor.startExpirationMonitoring()
            
        case .redirect:
            return
            
        case .needAuth:
            return
        }
    }
}

// MARK: - MainRoutingModuleInput

extension MainRoutingPresenter: MainRoutingModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
}

// MARK: - MainRoutingViewOutput

extension MainRoutingPresenter: MainRoutingViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        interactor.startExpirationMonitoring()
        
        modularFlows = interactor.prepareFlows()
        setupFlowsCallbacks()
        presentInitialState()
        
        interactor.registerRemoteNotifications()
        interactor.updateRemoteNotifications()
        interactor.checkForNewFirebaseToken()
        
        addSnackBarRoot()
    }
    
    func addSnackBarRoot() {
        let snackBarRoot = router.getSnackBarsRoot()
        view.presentSnackBarRoot(snackBarRoot)
    }
    
    func didTouchScreen() {
        interactor.expirePreventAction()
    }
    
    func actionDidBecomeActive() {
        interactor.updateRemoteNotifications()
    }
}

extension MainRoutingPresenter: AllCurrenciesModuleOutput {
    func didSelectAccount(account: AccountInfo) {
        guard let flow = (modularFlows.first { $0 === account }) else {
            return
        }
        setChoosenFlow(flow: flow)
    }
    
    func didGlobalLogout() {
        interactor.makeGlobalLogout()
    }
    
    func didAddAccount(account: AccountInfo) {
        guard let flow = (modularFlows.first { $0 === account }) else {
            return
        }
        currentFlow = flow
        didSelectFlow(flow: .auth(needShowBack: true))
        currentFlow = nil
    }
}

extension MainRoutingPresenter: ChangePinModuleOutput {
    func didChangePin() {
        view.dismissModal(animated: true)
    }
    
    func didCancelChangePin() {
        view.dismissModal(animated: true)
    }
}

extension MainRoutingPresenter: UnlockPinModuleOutput {
    func actionDidVerifyPin(pin: String) {
        interactor.processAllCommands(pin: pin)
        view.dismissModal(animated: true)
    }
    
    func actionCancelVerify() {
        interactor.cancellAllCommands()
        view.dismissModal(animated: true)
    }
}

extension MainRoutingPresenter: SessionVerificationModuleOutput {
    func actionDidSessionVerified() {
        sessionState = .notExpired
        interactor.startExpirationMonitoring()
        view.dismissModal(animated: true)
    }
    
    func actionDidCancelVerify() {
        sessionState = .expired
    }
    
    func actionLogout() {
        sessionState = .expired
        view.dismissModal(animated: false)
        interactor.makeGlobalLogout()
    }
}

// MARK: - MainRoutingInteractorOutput

extension MainRoutingPresenter: MainRoutingInteractorOutput {
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        view.presentSnackBar(snackBar)
    }
    
    func didPrivateLogout() {
        if isMultiWalletMode {
            view.dismissFlow(animated: true, all: true)
        } else {
            interactor.makeGlobalLogout()
        }
    }
    
    func didRequestPin() {
        let unlock = router.getUnlockPinModule(output: self)
        view.setModal(screen: unlock.viewController, animated: true)
    }

    func didExpireSession() {
        interactor.stopExpirationMonitoring()
        interactor.cancellAllCommands()
        let session = router.getSessionVerification(output: self)
        let controler = session.viewController.wrapToNavigationController(BaseNavigationController())
        view.setModal(screen: controler, animated: true)
    }
}
