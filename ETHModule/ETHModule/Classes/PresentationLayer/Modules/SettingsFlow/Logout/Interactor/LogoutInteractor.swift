//
//  LogoutLogoutInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

class LogoutInteractor {
    weak var output: LogoutInteractorOutput!
    var authService: ETHAuthService!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var settingsConfiguration: ETHSettingsConfiguration!
    var notificationFacade: ETHNotificationFacade!
}

// MARK: - LogoutInteractorInput

extension LogoutInteractor: LogoutInteractorInput {
    func clearServices() {
        if let wallets = try? authService.getWallets() {
            wallets.forEach {
                let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: $0)
                let command = SecureDataRemoveCommand(key: key) { _ in }
                sensitiveDataActionHandler.processCommand(command)
            }
        }
        
        authService.clear()
    }
    
    func unsubscribe() {
        if settingsConfiguration.isMultiWallet {
            notificationFacade.unsubscribe(clearPossibleAddresses: true) { result in
                switch result {
                case .success:
                    print("Successfully unsubscribed")
                    
                case .failure:
                    print("Failed to unsubscribe")
                }
            }
        }
    }
}
