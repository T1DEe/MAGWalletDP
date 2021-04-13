//
//  SettingsSettingsInteractor.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule

class SettingsInteractor {
    weak var output: SettingsInteractorOutput!
    var fingerprintAccessService: FingerprintAccessService!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var flowNotificationFacade: FlowNotificationFacade!
}

// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
    func getScreenModel() {
        flowNotificationFacade.getNotificationStatus { [weak self] result in
            guard let self = self else {
                return
            }
            var status: Bool
            
            switch result {
            case .authorized:
                status = self.flowNotificationFacade.isNotificationsEnabled
                
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
        flowNotificationFacade.getNotificationStatus(completion: completion)
    }
    
    func changeNotificationState(accounts: [AccountInfo], value: Bool) {
        guard let flows = accounts as? [Notifiable] else {
            return
        }
        
        if value {
            flowNotificationFacade.subscribe(flows: flows) { [weak self] result in
                switch result {
                case .success:
                    self?.flowNotificationFacade.isNotificationsEnabled = value
                    
                case .failure:
                    self?.flowNotificationFacade.isNotificationsEnabled = !value
                    DispatchQueue.main.async { [weak self] in
                        self?.output.didGetNotificationError()
                    }
                }
            }
        } else {
            flowNotificationFacade.unsubscribe(flows: flows, clearPossibleAddresses: false) { [weak self] result in
                switch result {
                case .success:
                    self?.flowNotificationFacade.isNotificationsEnabled = value
                    
                case .failure:
                    self?.flowNotificationFacade.isNotificationsEnabled = !value
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
    
    private func getScreenModelWithNotification(notificationStatus: Bool) -> SettingsEntity {
        var elements: [SettingsElementType] = [.changePin, .multiAccounts, .autoblock]
        
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
        
        elements.append(.changeNetwork)
        
        elements.append(.notifications(notificationStatus))
        elements.append(.logout)
        
        let model = SettingsEntity(elements: elements)
        
        return model
    }
}
