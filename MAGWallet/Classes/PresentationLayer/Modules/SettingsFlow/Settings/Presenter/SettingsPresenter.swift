//
//  SettingsSettingsPresenter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

class SettingsPresenter {
    weak var view: SettingsViewInput!
    weak var output: SettingsModuleOutput?
    
    var interactor: SettingsInteractorInput!
    var router: SettingsRouterInput!
    var accountsHolders: [AccountInfo] = []
    var networks: [NetworkConfigurable] = []
}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
  	var viewController: UIViewController {
        return view.viewController
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
            
        case .changeNetwork:
            router.presentChangeNetwork(output: self, networks: networks)
            
        case .autoblock:
            router.presentAutoblock(output: self)
            
        case .multiAccounts:
            router.presentMultiAccounts(output: self, accountsHolders: accountsHolders)
            
        default:
            break
        }
    }
    
    func actionBiometricToggled(_ value: Bool) {
        interactor.changeBiometricState(value)
    }
    
    func actionCheckNotificationsDenied() {        
        interactor.getScreenModel()
    }
    
    func actionNotificationsToggled(_ value: Bool) {
        interactor.getNotificationStatus { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .authorized:
                self.interactor.changeNotificationState(accounts: self.accountsHolders, value: value)
                
            case .denied:
                self.interactor.getScreenModel()
                DispatchQueue.main.async { [weak self] in
                    self?.presentSettingsSnackbar()
                }
            }
        }
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
    
    func actionBack() {
        view.dissmiss()
    }
    
    func didGetScreenModel(model: SettingsEntity) {
        view.setupInitialState(model: model)
    }
    
    func didGetNotificationError() {
        presentNoInternetSnackbar()
        interactor.getScreenModel()
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
}

extension SettingsPresenter: MultiAccountsModuleOutput {
    func didAddAccount(account: AccountInfo) {
        output?.didAddAccount(account: account)
    }
}

extension SettingsPresenter: ChangeNetworkModuleOutput {
}

extension SettingsPresenter: ButtonSnackBarModuleOutput {
    func actionRightButton(snackBar: ButtonSnackBarViewInput) {
        router.openSettings()
    }
    
    func actionLeftButton(snackBar: ButtonSnackBarViewInput) {
        interactor.getScreenModel()
    }
}

extension SettingsPresenter: OneButtonSnackBarModuleOutput {
}

// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput { }
