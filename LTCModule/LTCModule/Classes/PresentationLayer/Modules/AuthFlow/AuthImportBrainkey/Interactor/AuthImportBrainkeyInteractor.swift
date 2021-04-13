//
//  AuthImportBrainkeyAuthImportBrainkeyInteractor.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class AuthImportBrainkeyInteractor {
    weak var output: AuthImportBrainkeyInteractorOutput!
    var authService: LTCAuthService!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var authActionHandler: AuthEventActionHandler!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
}

// MARK: - AuthImportBrainkeyInteractorInput

extension AuthImportBrainkeyInteractor: AuthImportBrainkeyInteractorInput {
    func isValidSeed(seed: String?) -> Bool {
        guard let seed = seed else {
            return false
        }
        let formattedSeed = prepareSeed(seed: seed).seed
        let wordsCount = prepareSeed(seed: seed).wordsCount
        return authService.verifySeed(formattedSeed) && wordsCount == Constants.AuthConstants.seedWordsCount
    }
    
    func importAccount(seed: String) {
        guard isValidSeed(seed: seed) else {
            return
        }
        let formattedSeed = prepareSeed(seed: seed).seed
        do {
            let wallet = try authService.createWallet(seed: formattedSeed)
            if authService.isWalletExist(wallet) {
                let title = R.string.localization.importErrorTitle()
                let message = R.string.localization.authFlowImportAlreadyExistError()
                let model = getButtonSnackBarModel(title: title, message: message)
                output.didErrorOccurr(model)
            } else {
                output.didCreateWallet(wallet: wallet, seed: formattedSeed)
            }
        } catch {
            let title = R.string.localization.importErrorTitle()
            let message = R.string.localization.somethingWrongMessage()
            let model = getButtonSnackBarModel(title: title, message: message)
            output.didErrorOccurr(model)
        }
    }
    
    func saveSeedAndWallet(wallet: LTCWallet, seed: String) {
        let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: wallet)
        let command = SecureDataStoreCommand(value: seed, key: key) { [weak self] result in
            switch result {
            case .success:
                do {
                    try self?.authService.saveWallet(wallet, makeCurrent: true)
                    self?.output.didLoginSuccess()
                } catch {
                    self?.output.didErrorOccurr(self?.getDefaultErrorSnackBarModel())
                }

            case .failure(let error):
                switch error {
                case .userCanceled:
                    self?.output.didErrorOccurr(nil)
                    
                default:
                    let title = R.string.localization.importErrorTitle()
                    let message = R.string.localization.saveSensitiveDataError()
                    let model = self?.getButtonSnackBarModel(title: title,
                                                             message: message)
                    self?.output.didErrorOccurr(model)
                }
            }
        }
        sensitiveDataActionHandler.processCommand(command)
    }
    
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func comleteAuth() {
        authActionHandler.actionAuthCompleted()
    }
    
    // MARK: Private
    
    private func getDefaultErrorSnackBarModel() -> ButtonSnackBarModel {
        let title = R.string.localization.importErrorTitle()
        let message = R.string.localization.authFlowImportSaveWalletError()

        let model = getButtonSnackBarModel(title: title,
                                           message: message)
        return model
    }

    private func getButtonSnackBarModel(title: String, message: String) -> ButtonSnackBarModel {
        return ButtonSnackBarModel(isBlocker: false,
                                   isError: true,
                                   title: title,
                                   message: message,
                                   leftButtonTitle: R.string.localization.errorCancelButtonTitle(),
                                   rightButtonTitle: R.string.localization.errorTryAgainButtonTitle())
    }
    
    private func prepareSeed(seed: String) -> (seed: String, wordsCount: Int) {
        let wordsArray = seed.split(separator: " ").map { String($0) }
        var editedSeed = ""
        
        // remove enters and empty strings
        var validWordsArray = [String]()
        for word in wordsArray {
            let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedWord.isEmpty {
                continue
            }
            
            validWordsArray.append(trimmedWord)
        }
        editedSeed = validWordsArray.joined(separator: " ")
        
        return (editedSeed, validWordsArray.count)
    }
}
