//
//  AppDelegate.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var applicationAssembler = ApplicationAssembler.shared
    
    var flowNotificationFacade: FlowNotificationFacade! {
        return applicationAssembler.assembler.resolver.resolve(FlowNotificationFacade.self)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = applicationAssembler.assembler.resolver.resolve(UIWindow.self)
        self.window?.makeKeyAndVisible()
        // swiftlint:disable force_unwrapping
        let configurators: [ConfiguratorProtocol] = applicationAssembler.assembler.resolver.resolve([ConfiguratorProtocol].self)!
        // swiftlint:enable force_unwrapping
        for configurator in configurators {
            configurator.configure()
        }
        
        return true
    }
}

extension AppDelegate {
    static var currentDelegate: AppDelegate {
        // swiftlint:disable force_cast
        return UIApplication.shared.delegate as! AppDelegate
        // swiftlint:enable force_cast
    }

    static var moduleAssembly: ModuleAssembly {
        // swiftlint:disable force_unwrapping
        return applicationAssembler.assembler.resolver.resolve(ModuleAssembly.self)!
        // swiftlint:enable force_unwrapping
    }

    static var currentWindow: UIWindow {
        // swiftlint:disable force_unwrapping
        return currentDelegate.window!
        // swiftlint:enable force_unwrapping
    }

    static var applicationAssembler: ApplicationAssembler {
        return currentDelegate.applicationAssembler
    }
}

extension AppDelegate {    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        flowNotificationFacade.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
}
