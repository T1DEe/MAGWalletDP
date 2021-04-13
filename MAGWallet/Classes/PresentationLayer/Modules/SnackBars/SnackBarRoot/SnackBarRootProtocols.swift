//
//  SnackBarRootSnackBarRootProtocols.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol SnackBarRootViewInput: class, Presentable {
    func setupInitialState(snackBar: SnackBarRootModel)
    func removeSnackBarView(snackBar: SnackBarRootModel)
}

protocol SnackBarRootViewOutput {
    func viewIsReady()
    func actionOnEmptyPlaceTap()
    func didRemoveSnackBarView()
    func actionSwipeDown()
}

protocol SnackBarRootModuleInput: class {
	var viewController: UIViewController { get }
	var output: SnackBarRootModuleOutput? { get set }
    
    func presentSnackBar(snackBar: SnackBarPresentable, animated: Bool)
    func removeSnackBar(snackBar: SnackBarPresentable)
}

protocol SnackBarRootModuleOutput: class {
}

protocol SnackBarRootInteractorInput {
    func startTimer()
    func stopTimer()
}

protocol SnackBarRootInteractorOutput: class {
    func hideSnackBar()
}

protocol SnackBarRootRouterInput {
}
