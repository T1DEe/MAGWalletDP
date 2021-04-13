//
//  AuthCopyWifAuthCreateAndCopyInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

class AuthCreateAndCopyInteractor {
    weak var output: AuthCreateAndCopyInteractorOutput!
    var authService: ETHAuthService!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var authActionHandler: AuthEventActionHandler!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var notificationFacade: ETHNotificationFacade!
}

// MARK: - AuthCreateAndCopyInteractorInput

extension AuthCreateAndCopyInteractor: AuthCreateAndCopyInteractorInput {
    func createRandomWallet() -> (wallet: ETHWallet, seed: String)? {
        let seed = authService.getSeed()
        if let wallet = try? authService.createWallet(seed: seed) {
            return (wallet, seed)
        }
        
        return nil
    }
    
    func saveBrainkey(wallet: ETHWallet, seed: String) {
        let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: wallet)
        let command = SecureDataStoreCommand(value: seed, key: key) { [weak self] result in
            switch result {
            case .success:
                self?.output.didBrainKeySave()

            case .failure(let error):
                switch error {
                case .userCanceled:
                    self?.output.didFailSaveBrainkey(nil)

                default:
                    let title = R.string.localization.importErrorTitle()
                    let message = R.string.localization.saveSensitiveDataError()
                    let model = self?.getButtonSnackBarModel(title: title,
                                                             message: message)
                    self?.output.didFailSaveBrainkey(model)
                }
            }
        }
        sensitiveDataActionHandler.processCommand(command)
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func saveWallet(wallet: ETHWallet) {
        try? authService.saveWallet(wallet, makeCurrent: true)
    }
    
    func subscribeToNotificationsIfNeeded(wallet: ETHWallet) {
        if notificationFacade.isNotificationsEnabled {
            notificationFacade.subscribeWallet(wallet) { result in
                switch result {
                case .success:
                    print("Successfully subscribed to \(wallet.address)")
                    
                case .failure:
                    print("Failed to subscribe \(wallet.address)")
                }
            }
        }
    }
    
    func comleteAuth() {
        authActionHandler.actionAuthCompleted()
    }
    
    // MARK: Private
    
    private func getButtonSnackBarModel(title: String, message: String) -> ButtonSnackBarModel {
        return ButtonSnackBarModel(isBlocker: false,
                                   isError: true,
                                   title: title,
                                   message: message,
                                   leftButtonTitle: R.string.localization.errorCancelButtonTitle(),
                                   rightButtonTitle: R.string.localization.errorTryAgainButtonTitle())
    }
}
