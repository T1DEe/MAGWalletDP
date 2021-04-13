//
//  MainRoutingMainRoutingProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SafariServices
import SharedFilesModule
import UIKit

enum FlowUILevel {
    case flow
    case modal
    case fronOfAll
}

enum MainRoutingViewMode {
    case asRoot
    case push
    case asRootExeptFirst
}

protocol MainRoutingViewInput: class, Presentable {
    func setupInitialState()

    func setFlow(screen: UIViewController, animated: Bool, mode: MainRoutingViewMode)
    func dismissFlow(animated: Bool, all: Bool)
    func setModal(screen: UIViewController, animated: Bool)
    func dismissModal(animated: Bool)

    func presentSnackBarRoot(_ snackBarRoot: SnackBarRootModuleInput)
    func presentSnackBar(_ snackBar: SnackBarPresentable)
}

protocol MainRoutingViewOutput {
    func viewIsReady()
    func didTouchScreen()
    func actionDidBecomeActive()
}

protocol MainRoutingModuleInput: class {
    var viewController: UIViewController { get }
    var output: MainRoutingModuleOutput? { get set }
}

protocol MainRoutingModuleOutput: class {
}

protocol MainRoutingInteractorInput {
    func bindToEvents()
    func prepareFlows() -> [ModularSubflow]
    func validatePin(pin: String) -> Bool
    func processAllCommands(pin: String)
    func cancellAllCommands()
    func makeGlobalLogout()
    func startExpirationMonitoring()
    func stopExpirationMonitoring()
    func expirePreventAction()
    func isSessionExpired() -> Bool
    func registerRemoteNotifications()
    func updateRemoteNotifications()
    func checkForNewFirebaseToken()
}

protocol MainRoutingInteractorOutput: class {
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func didRequestPin()
    func didRequestChangePin()
    func didShowExplorer(url: URL)
    func didPrivateLogout()
    func didExpireSession()
}

protocol MainRoutingRouterInput {
    func getUnlockPinModule(output: UnlockPinModuleOutput) -> UnlockPinModuleInput
    func getChangePinModule(output: ChangePinModuleOutput) -> ChangePinModuleInput
    func getSessionVerification(output: SessionVerificationModuleOutput) -> SessionVerificationModuleInput
    func getSnackBarsRoot() -> SnackBarRootModuleInput
    func getAllCurrencies(output: AllCurrenciesModuleOutput, accounts: [AccountInfo], networks: [NetworkConfigurable]) -> AllCurrenciesModuleInput
    func getSafariVC(url: URL) -> SFSafariViewController
}
