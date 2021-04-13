//
//  RootRootRouter.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import SharedUIModule
import UIKit

class RootRouter: RootRouterInput {
    weak var view: UIViewController?
    weak var verification: UIViewController?
    weak var splash: UIViewController?
    weak var authNavigation: UINavigationController?

    var childs = NSPointerArray.weakObjects()
}

extension RootRouter {
    func presentPinVerification(output: PinVerificationModuleOutput) {
        guard let view = view else {
            return
        }
        
        clearChildsStack()

        let module = PinVerificationModuleConfigurator().configureModule()
        module.output = output
        let viewController = module.viewController.wrapToNavigationController(BaseNavigationController())
        view.addChildController(child: viewController)
        childs.addObject(viewController)

        appendFadeout(view, scale: 0.8)
    }

    func presentSplash() {
        guard let view = view else {
            return
        }

        let viewController = SplashModuleConfigurator().configureModule().viewController
        splash = viewController
        view.addChildController(child: viewController)
        childs.addObject(viewController)
    }

    func presentMain(output: MainRoutingModuleOutput) {
        guard let view = view else {
            return
        }

        clearChildsStack()

        let module = MainRoutingModuleConfigurator().configureModule()
        module.output = output
        let viewController = module.viewController
        view.addChildController(child: viewController)
        childs.addObject(viewController)

        appendFadeout(view, scale: 0.5)
    }

    func presentCreatePin(output: CreatePinModuleOutput) {
        guard let view = view else {
            return
        }
        
        clearChildsStack()
        
        let module = CreatePinModuleConfigurator().configureModule()
        module.output = output
        let viewController = module.viewController
        view.addChildController(child: viewController)
        childs.addObject(viewController)

        appendFadeout(view, scale: 0.8)
    }

    func presentChangePin(output: ChangePinModuleOutput) {
        guard let view = view else {
            return
        }
        let module = ChangePinModuleConfigurator().configureModule()
        module.output = output
        let viewController = module.viewController
        view.addChildController(child: viewController)
        childs.addObject(viewController)

        appendFadeout(view, scale: 0.8)
    }

    private func appendFadeout(_ rootView: UIViewController, scale: CGFloat) {
        let window = AppDelegate.currentWindow

        if let snapshot = window.snapshotView(afterScreenUpdates: false) {
            rootView.view.addSubview(snapshot)

            UIView.animate(withDuration: 0.3, animations: {
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(scale, scale, scale)
            }) { _ in
                snapshot.removeFromSuperview()
            }
        }
    }

    private func clearChildsStack() {
        guard let view = view else {
            return
        }

        if view.children.isEmpty == false {
            let viewControllers: [UIViewController] = view.children

            for viewContoller in viewControllers {
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }

    private func getTopViewController() -> UIViewController? {
        let windowsRoot = AppDelegate.currentWindow.rootViewController
        let topViewController = windowsRoot
        return topViewController
    }
}
