//
//  AuthCopyWifAuthCreateAndCopyProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol AuthCreateAndCopyViewInput: class, Presentable {
    func setupInitialState(seed: String)
}

protocol AuthCreateAndCopyViewOutput {
    func viewIsReady()
    func actionBack()
    func actionContinue()
    func actionCopy()
}

protocol AuthCreateAndCopyModuleInput: class {
	var viewController: UIViewController { get }
	var output: AuthCreateAndCopyModuleOutput? { get set }
}

protocol AuthCreateAndCopyModuleOutput: class {
}

protocol AuthCreateAndCopyInteractorInput {
    func createRandomWallet() -> (wallet: ETHWallet, seed: String)?
    func saveBrainkey(wallet: ETHWallet, seed: String)
    func saveWallet(wallet: ETHWallet)
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func subscribeToNotificationsIfNeeded(wallet: ETHWallet)
    func comleteAuth()
}

protocol AuthCreateAndCopyInteractorOutput: class {
    func didBrainKeySave()
    func didFailSaveBrainkey(_ error: ButtonSnackBarModel?)
    func didFailCreateWallet(_ error: ButtonSnackBarModel?)
}

protocol AuthCreateAndCopyRouterInput {
    func getButtonSnackBar() -> ButtonSnackBarModuleInput
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
}
