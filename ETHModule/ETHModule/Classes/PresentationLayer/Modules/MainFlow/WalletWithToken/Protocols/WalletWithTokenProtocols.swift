//
//  WalletWithTokenWalletWithTokenProtocols.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol WalletWithTokenViewInput: class, Presentable {
    func setupAddress(entity: WalletAddressEntity)
    func setupBalance(entity: WalletBalanceEntity)
    func setupTokenBalance(entity: WalletTokenBalanceEntity)
    func setupBalanceRate(entity: WalletBalanceRateEntity)
    func setupState(height: CGFloat)
    func setupButtonState(isBackButtonHidden: Bool)
}

protocol WalletWithTokenViewOutput {
    func viewIsReady()
    func viewIsReadyToShow()
    func actionSettings()
    func actionCopy(text: String)
    func actionQRcode()
    func actionBack()
}

protocol WalletWithTokenInteractorInput {
    func bindToEvents()
    func obtainAddressEntity() -> WalletAddressEntity
    func obtainInitialBalanceEntity() -> WalletBalanceEntity
    func obtainInitialTokenBalanceEntity() -> WalletTokenBalanceEntity
    func obtainInitialBalanceRate() -> WalletBalanceRateEntity
    func updateBalanceInfo()
    func updateTokenBalanceInfo()
    func presentSnackBar(_ snackBar: SnackBarPresentable)
}

protocol WalletWithTokenInteractorOutput: class {
    func didNewWalletSelected()
    func didUpdateBalance(entity: WalletBalanceEntity)
    func didUpdateTokenBalance(entity: WalletTokenBalanceEntity)
    func didUpdateBalanceRate(entity: WalletBalanceRateEntity)
}

protocol WalletWithTokenRouterInput {
    func getOneButtonSnackBar() -> OneButtonSnackBarModuleInput 
}
