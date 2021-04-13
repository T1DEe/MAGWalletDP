//
//  SettingsSettingsProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol SettingsViewInput: class, Presentable {
    func setupInitialState(model: SettingsEntity)
    func setVersion(version: String)
}

protocol SettingsViewOutput {
    func viewIsReady()
    func actionElementSelected(_ element: SettingsElementType)
    func actionBiometricToggled(_ value: Bool)
    func actionNotificationsToggled(_ value: Bool)
    func actionCheckNotificationsDenied()
    func actionBack()
}

protocol SettingsModuleInput: SubflowModule {
    var viewController: UIViewController { get }
    var output: SettingsModuleOutput? { get set }
}

protocol SettingsModuleOutput: class {
    func didSelectBack()
    func didLogoutAction()
    func didChangePinAction()
    func didSelectAddAccount()
    func didGetNoWallets()
}

protocol SettingsInteractorInput {
    func getScreenModel()
    func getBrainkey()
    func getVersion() -> String
    func changeBiometricState(_ value: Bool)
    func changeNotificationState(value: Bool)
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void)
    func makeShowSnackBarEvent(_ snackbar: SnackBarPresentable)
}

protocol SettingsInteractorOutput: class {
    func didBrainkeyReceive(brainkey: String)
    func didGetScreenModel(model: SettingsEntity)
    func didGetNotificationError()
}

protocol SettingsRouterInput {
    func presentLogout(output: LogoutModuleOutput)
    func presentAutoblock(output: AutoblockModuleOutput)
    func presentExport(brainkey: String)
    func presentAccounts(output: AccountsModuleOutput)
    func presentChangeNetwork(output: ChangeNetworkModuleOutput)
    func getButtonSnackBar() -> ButtonSnackBarModuleInput
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
    func openSettings()
}
