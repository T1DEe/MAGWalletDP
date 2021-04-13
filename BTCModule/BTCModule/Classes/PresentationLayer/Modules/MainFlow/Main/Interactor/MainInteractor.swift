//
//  MainMainInteractor.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

class MainInteractor {
    weak var output: MainInteractorOutput!
    var settingsConfiguration: BTCSettingsConfiguration!
}

// MARK: - MainInteractorInput

extension MainInteractor: MainInteractorInput {
}
