//
//  ModuleAssembly.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Swinject

class ModuleAssembly {
    fileprivate let assembler: Assembler!

    public var resolver: Resolver {
        return assembler.resolver
    }
    
    init(parent: Assembler) {
        assembler = Assembler(
            [
                RootModuleAssembler(),
                SplashModuleAssembler(),
                CreatePinModuleAssembler(),
                PinVerificationModuleAssembler(),
                MainRoutingModuleAssembler(),
                ChangePinModuleAssembler(),
                SnackBarRootModuleAssembler(),
                UnlockPinModuleAssembler(),
                SessionVerificationModuleAssembler(),
                AllCurrenciesModuleAssembler(),
                SettingsModuleAssembler(),
                LogoutModuleAssembler(),
                AutoblockModuleAssembler(),
                ChangeNetworkModuleAssembler(),
                MultiAccountsModuleAssembler(),
                ButtonSnackBarModuleAssembler(),
                OneButtonSnackBarModuleAssembler(),
                ForgotPinModuleAssembler()
            ],
            parent: parent
        )
    }
}
