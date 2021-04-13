//
//  LogoutLogoutProtocols.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

protocol LogoutViewInput: class, Presentable {
    func setupInitialState()
}

protocol LogoutViewOutput {
    func viewIsReady()
    func actionCancel()
    func actionConfirm()
}

protocol LogoutModuleInput: class {
    var viewController: UIViewController { get }
    var output: LogoutModuleOutput? { get set }
}

protocol LogoutModuleOutput: class {
    func didLogoutAction()
    func didChangePinAction()
}

protocol LogoutInteractorInput {
    func clearServices()
    func unsubscribe()
}

protocol LogoutInteractorOutput: class {
}

protocol LogoutRouterInput {
}
