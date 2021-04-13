//
//  SettingsSettingsInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class SettingsInteractor {
    weak var output: SettingsInteractorOutput!
    var authService: ETHAuthService!
    var settingsConfiguration: ETHSettingsConfiguration!
    var sensitiveDataActionHandler: SensitiveDataEventActionHandler!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var sensitiveDataKeysCore: SensitiveDataKeysCoreComponent!
    var fingerprintAccessService: FingerprintAccessService!
    var networkFacade: ETHNetworkFacade!
    var notificationFacade: ETHNotificationFacade!
}

// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {    
    func getScreenModel() {
        if settingsConfiguration.isMultiWallet {
            let model = getScreenModelWithNotification(notificationStatus: .none)
            output.didGetScreenModel(model: model)
        } else {
            notificationFacade.getNotificationStatus { [weak self] result in
                guard let self = self else {
                    return
                }
                var status: Bool
                
                switch result {
                case .authorized:
                    status = self.notificationFacade.isNotificationsEnabled
                    
                case .denied:
                    status = false
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    let model = self.getScreenModelWithNotification(notificationStatus: status)
                    self.output.didGetScreenModel(model: model)
                }
            }
        }
    }
    
    func getBrainkey() {
        guard let wallet = try? authService.getCurrentWallet() else {
            return
        }
        let key = sensitiveDataKeysCore.generateSensitiveSeedKey(wallet: wallet)
        let command = SecureDataLoadCommand(key: key) { [weak self] result in
            switch result {
            case .success(let wif):
                self?.output.didBrainkeyReceive(brainkey: wif)

            case .failure(let error):
                print("Ooooooups get wif: \(error)")
            }
        }
        sensitiveDataActionHandler.processCommand(command)
    }
    
    func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return "version: " + version
    }
    
    func changeBiometricState(_ value: Bool) {
        fingerprintAccessService.isOn = value
    }
    
    func getNotificationStatus(completion: @escaping (NotificationSettings) -> Void) {
        notificationFacade.getNotificationStatus(completion: completion)
    }
    
    func changeNotificationState(value: Bool) {
        if value {
            notificationFacade.subscribe { [weak self] result in
                switch result {
                case .success:
                    self?.notificationFacade.isNotificationsEnabled = value
                    
                case .failure:
                    self?.notificationFacade.isNotificationsEnabled = !value
                    DispatchQueue.main.async { [weak self] in
                        self?.output.didGetNotificationError()
                    }
                }
            }
        } else {
            notificationFacade.unsubscribe( clearPossibleAddresses: false) { [weak self] result in
                switch result {
                case .success:
                    self?.notificationFacade.isNotificationsEnabled = value
                    
                case .failure:
                    self?.notificationFacade.isNotificationsEnabled = !value
                    DispatchQueue.main.async { [weak self] in
                        self?.output.didGetNotificationError()
                    }
                }
            }
        }
    }
    
    func makeShowSnackBarEvent(_ snackbar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackbar)
    }
    
    private func getScreenModelWithNotification(notificationStatus: Bool?) -> SettingsEntity {
        var elements: [SettingsElementType]
        if settingsConfiguration.isUniqueWallet {
            elements = [.changePin, .backup, .autoblock]
            if fingerprintAccessService.isEnabled && fingerprintAccessService.biometryType != .none {
                switch fingerprintAccessService.biometryType {
                case .touchId:
                    elements.append(.touchId(fingerprintAccessService.isOn))
                    
                case .faceId:
                    elements.append(.faceId(fingerprintAccessService.isOn))
                    
                default:
                    break
                }
            }
        } else {
            elements = [.accounts, .backup]
        }
        
        if !networkFacade.usingOnlyDefaultNetwork() {
            elements.append(.changeNetwork)
        }
        
        if let notificationStatus = notificationStatus {
            elements.append(.notifications(notificationStatus))
        }
        
        elements.append(.logout)
        
        let model = SettingsEntity(elements: elements)
        return model
    }
}
