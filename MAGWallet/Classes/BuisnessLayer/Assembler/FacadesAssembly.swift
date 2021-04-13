//
//  FacadesAssembly.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import SharedFilesModule
import Swinject

final class FacadesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FlowNotificationFacade.self) { resolver in
            let facade = FlowNotificationFacadeImp()
            facade.notificationService = resolver.resolve(NotificationService.self)
            facade.firebaseService = resolver.resolve(FirebaseService.self)
            return facade
        }
        .inObjectScope(.container)
    }
}
