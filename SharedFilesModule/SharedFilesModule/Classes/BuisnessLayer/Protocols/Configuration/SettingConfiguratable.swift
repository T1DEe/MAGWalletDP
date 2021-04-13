//
//  SettingConfiguratable.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public protocol SettingConfiguratable {
    func obtainConfiguration() -> SettingsConfiguration
}
