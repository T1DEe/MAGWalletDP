//
//  ModuleAssembly.swift
//  BTCModule
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
                ApplicationModuleModuleAssembler(),
                AuthRootModuleAssembler(),
                AuthFlowSelectionModuleAssembler(),
                AuthCreateAndCopyModuleAssembler(),
                AuthImportBrainkeyModuleAssembler(),
                MainModuleAssembler(),
                ScanModuleAssembler(),
                SendModuleAssembler(),
                SettingsModuleAssembler(),
                OneButtonSnackBarModuleAssembler(),
                AutoblockModuleAssembler(),
                ChangeNetworkModuleAssembler(),
                AccountsModuleAssembler(),
                ExportBrainkeyModuleAssembler(),
                LogoutModuleAssembler(),
                ReceiveModuleAssembler(),
                HistoryModuleAssembler(),
                WalletModuleAssembler(),
                ButtonSnackBarModuleAssembler(),
                ApplySnackBarModuleAssembler(),
                HistoryDetailsModuleAssembler()
            ],
            parent: parent
        )
    }
}
