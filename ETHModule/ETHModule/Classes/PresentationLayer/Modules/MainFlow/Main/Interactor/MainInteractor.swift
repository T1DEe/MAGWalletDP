//
//  MainMainInteractor.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

class MainInteractor {
    weak var output: MainInteractorOutput!
    var settingsConfiguration: ETHSettingsConfiguration!
    var snackBarsActionHandler: SnackBarsActionHandler!
}

// MARK: - MainInteractorInput

extension MainInteractor: MainInteractorInput {
    func hasAdditionToken() -> Bool {
        return settingsConfiguration.hasAdditionalToken
    }
    
    func presentSnackbar(snackBar: SnackBarPresentable) {
        snackBarsActionHandler.actionPresentSnackBar(snackBar)
    }
}
