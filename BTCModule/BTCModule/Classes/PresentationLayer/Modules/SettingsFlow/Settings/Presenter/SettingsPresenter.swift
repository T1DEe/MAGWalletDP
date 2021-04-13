//
//  SettingsSettingsPresenter.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedUIModule
import UIKit

class SettingsPresenter: OneButtonSnackBarModuleOutput {
    weak var view: SettingsViewInput!
    weak var output: SettingsModuleOutput?
    
    var interactor: SettingsInteractorInput!
    var router: SettingsRouterInput!
    weak var navController: UIViewController?

    func getViewController() -> UIViewController {
        if let navController = navController {
            return navController
        } else {
            let controller = view.viewController.wrapToNavigationController(BaseNavigationController())
            navController = controller
            return controller
        }
    }
}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
  	var viewController: UIViewController {
    	return getViewController()
  	}
}

// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    func viewIsReady() {
        interactor.getScreenModel()
        let version = interactor.getVersion()
        view.setVersion(version: version)
    }
    
    func actionElementSelected(_ element: SettingsElementType) {
        switch element {
        case .logout:
            router.presentLogout(output: self)

        case .changePin:
            output?.didChangePinAction()
            
        case .autoblock:
            router.presentAutoblock(output: self)

        case .accounts:
            router.presentAccounts(output: self)
            
        case .backup:
            interactor.getBrainkey()
            
        case .changeNetwork:
            router.presentChangeNetwork(output: self)
            
        default:
            break
        }
    }
    
    func actionNotificationsToggled(_ value: Bool) {
        interactor.getNotificationStatus { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .authorized:
                self.interactor.changeNotificationState(value: value)
                
            case .denied:
                self.interactor.getScreenModel()
                DispatchQueue.main.async { [weak self] in
                    self?.presentSettingsSnackbar()
                }
            }
        }
    }
    
    func actionCheckNotificationsDenied() {
        interactor.getScreenModel()
    }
    
    func presentNoInternetSnackbar() {
        let snackBar = router.getOneButtonSnackBar()
        let model = OneButtonSnackBarModel(isBlocker: true,
                                           title: R.string.localization.settingsFlowNotificationsInternetTitle(),
                                           buttonTitle: R.string.localization.settingsFlowNotificationsInternetButton()
        )
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        interactor.makeShowSnackBarEvent(snackBar)
    }
    
    func presentSettingsSnackbar() {
        let snackBar = router.getButtonSnackBar()
        let model = ButtonSnackBarModel(isBlocker: true,
                                        isError: false,
                                        title: R.string.localization.settingsFlowNotificationsPermissionTitle(),
                                        message: R.string.localization.settingsFlowNotificationsPermissionMessage(),
                                        leftButtonTitle: R.string.localization.settingsFlowNotificationsPermissionCancel(),
                                        rightButtonTitle: R.string.localization.settingsFlowNotificationsPermissionOpen())
        snackBar.output = self
        snackBar.setButtonSnackBarModel(model)
        interactor.makeShowSnackBarEvent(snackBar)
    }
    
    func actionBack() {
        output?.didSelectBack()
    }
    
    func actionBiometricToggled(_ value: Bool) {
        interactor.changeBiometricState(value)
    }
}

extension SettingsPresenter: AutoblockModuleOutput {
    func didSelectAutoblockTime() {
    }
}

extension SettingsPresenter: LogoutModuleOutput {
    func didLogoutAction() {
        output?.didLogoutAction()
    }
    
    func didChangePinAction() {
        output?.didChangePinAction()
    }
}

extension SettingsPresenter: AccountsModuleOutput {
    func actionAddAccount() {
        output?.didSelectAddAccount()
    }
    
    func actionLogout() {
        output?.didLogoutAction()
    }
}

extension SettingsPresenter: ChangeNetworkModuleOutput {
    func didGetNoWallets() {
        output?.didGetNoWallets()
    }
}

extension SettingsPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        router.openSettings()
    }
    
    func actionLeftButton(snackBar: ButtonSnackBarViewInput) {
        interactor.getScreenModel()
    }
}

// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {
    func didGetScreenModel(model: SettingsEntity) {
        view.setupInitialState(model: model)
    }
    
    func didGetNotificationError() {
        presentNoInternetSnackbar()
        interactor.getScreenModel()
    }
    
    func didBrainkeyReceive(brainkey: String) {
        router.presentExport(brainkey: brainkey)
    }
}
