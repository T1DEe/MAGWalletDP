//
//  ReceiveReceiveInteractor.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class ReceiveInteractor {
    weak var output: ReceiveInteractorOutput!
    var snackBarsActionHandler: SnackBarsActionHandler!
    var qrCodeService: QRCodeCoreComponent!
    var authService: LTCAuthService!
}

// MARK: - ReceiveInteractorInput

extension ReceiveInteractor: ReceiveInteractorInput {
    func presentSnackBar(_ snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
    
    func obtainScreenEntity() -> ReceiveEntity {
        guard let wallet = try? authService.getCurrentWallet() else {
            return getEmptyEntity()
        }
        
        let entity = ReceiveEntity(address: wallet.address)
        
        return entity
    }
    
    func obtainQRCode(size: CGSize, entity: ReceiveEntity) {
        createLTCQRCodeImage(size: size, model: entity)
    }
    
    // MARK: - Private
    
    private func getEmptyEntity() -> ReceiveEntity {
        return ReceiveEntity(address: String())
    }
    
    private func createLTCQRCodeImage(size: CGSize, model: ReceiveEntity) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            let data = "bitcoin:" + model.address
            if let image = self.qrCodeService.generateQRCode(string: data, size: size) {
                DispatchQueue.main.async { [weak self] in
                    self?.output.didObtainQrcode(image: image)
                }
            }
        }
    }
}
