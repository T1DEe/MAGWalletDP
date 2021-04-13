//
//  ScanScanProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol ScanViewInput: class, Presentable {
    func setupInitialState()
    func startScanning()
    func stopScanning()
}

protocol ScanViewOutput {
    func viewIsReady()
    func actionBack()
    func actionScan(string: String)
    func cameraPermissionsDenied()
}

protocol ScanModuleInput: class {
	var viewController: UIViewController { get }
	var output: ScanModuleOutput? { get set }
}

protocol ScanModuleOutput: class {
    func didScanEthQr(entity: ScanEntity)
    func permissionsDenied()
}

protocol ScanInteractorInput {
    func parceEthScan(string: String) -> ScanEntity
    func presentSnackBar(_ snackBar: SnackBarPresentable)
}

protocol ScanInteractorOutput: class {
    func didFailScan()
}

protocol ScanRouterInput {
    func getButtonSnackBar() -> ButtonSnackBarModuleInput
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
    func openSettings()
}
