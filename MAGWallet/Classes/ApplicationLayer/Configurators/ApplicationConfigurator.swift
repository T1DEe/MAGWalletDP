//
//  ApplicationConfigurator.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class ApplicationConfigurator: ConfiguratorProtocol {
    func configure() {
        var rootView: UIViewController!

        let viewController = RootModuleConfigurator().configureModule().viewController
        rootView = viewController

        AppDelegate.currentWindow.rootViewController = rootView
    }
}
