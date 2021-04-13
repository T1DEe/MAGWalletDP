//
//  WalletWalletProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol WalletViewInput: class, Presentable {
    func setupState(entity: WalletEntity)
    func setupState(height: CGFloat)
    func setupBalanceRate(entity: WalletBalanceRateEntity)
    func setupButtonState(isBackButtonHidden: Bool)
}

protocol WalletViewOutput {
    func viewIsReady()
    func viewIsReadyToShow()
    func actionSettings()
    func actionCopy(text: String)
    func actionQRcode()
    func actionBack()
}

protocol WalletModuleInput: class {
	var viewController: UIViewController { get }
	var output: WalletModuleOutput? { get set }
    var needShowBack: Bool { get set }
    
    func heightDidChanged(height: CGFloat)
}

protocol WalletModuleOutput: class {
    func didSelectSettings()
    func didSelectQRCode()
    func didSelectBack()
}

protocol WalletInteractorInput {
    func bindToEvents()
    func obtainInitialEntity() -> WalletEntity
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity
    func updateBalanceInfo()
    
    func presentSnackBar(_ snackBar: SnackBarPresentable)
}

protocol WalletInteractorOutput: class {
    func didNewWalletSelected()
    func didUpdateBalance(entity: WalletEntity)
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity)
}

protocol WalletRouterInput {
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput
}
