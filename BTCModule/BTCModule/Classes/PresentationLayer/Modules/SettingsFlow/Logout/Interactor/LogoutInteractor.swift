//
//  LogoutLogoutInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

class LogoutInteractor {
    weak var output: LogoutInteractorOutput!
    var authService: BTCAuthService!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var settingsConfiguration: BTCSettingsConfiguration!
    var notificationFacade: BTCNotificationFacade!
}

// MARK: - LogoutInteractorInput

extension LogoutInteractor: LogoutInteractorInput {
    func clearServices() {
        if let wallets = try? authService.getWallets() {
            wallets.forEach { wallet in
                let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: wallet)
                let command = SecureDataRemoveCommand(key: key) { _ in }
                sensitiveDataActionHandler.processCommand(command)
            }
        }
        
        try? authService.clear()
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
