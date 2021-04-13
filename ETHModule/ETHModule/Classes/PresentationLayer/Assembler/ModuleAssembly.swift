//
//  ModuleAssembly.swift
//  ETHModule
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
                AuthImportBrainkeyModuleAssembler(),
                AuthCreateAndCopyModuleAssembler(),
                OneButtonSnackBarModuleAssembler(),
                ButtonSnackBarModuleAssembler(),
                SelectCurrencySnackBarModuleAssembler(),
                ApplySnackBarModuleAssembler(),
                MainModuleAssembler(),
                WalletModuleAssembler(),
                HistoryModuleAssembler(),
                WalletWithTokenModuleAssembler(),
                ReceiveModuleAssembler(),
                ScanModuleAssembler(),
                SettingsModuleAssembler(),
                LogoutModuleAssembler(),
                AutoblockModuleAssembler(),
                ChangeNetworkModuleAssembler(),
                ExportBrainkeyModuleAssembler(),
                SendModuleAssembler(),
                HistoryDetailsModuleAssembler(),
                AccountsModuleAssembler()
            ],
            parent: parent
        )
    }
}
