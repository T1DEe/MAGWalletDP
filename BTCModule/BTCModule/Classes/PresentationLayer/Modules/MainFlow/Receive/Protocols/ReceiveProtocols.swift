//
//  ReceiveReceiveProtocols.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ReceiveViewInput: class, Presentable {
    func setupState(entity: ReceiveEntity)
    func setupQRCodeImage(image: UIImage)
    func getqrCodeImageViewSize() -> CGSize
}

protocol ReceiveViewOutput {
    func viewIsReady()
    func actionBack()
    func actionCopy(text: String)
}

protocol ReceiveModuleInput: class {
	var viewController: UIViewController { get }
	var output: ReceiveModuleOutput? { get set }
}

protocol ReceiveModuleOutput: class {
}

protocol ReceiveInteractorInput {
    func presentSnackBar(_ snackBar: SnackBarPresentable)
    func obtainScreenEntity() -> ReceiveEntity
    func obtainQRCode(size: CGSize, entity: ReceiveEntity)
}

protocol ReceiveInteractorOutput: class {
    func didObtainQrcode(image: UIImage)
}

protocol ReceiveRouterInput {
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
}
