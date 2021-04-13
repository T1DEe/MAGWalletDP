//
//  SettingsType.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public typealias SettingsTypeAction = () -> Void

public enum SettingsType {
    case changePin(SettingsTypeAction)
    case autoblock(SettingsTypeAction)
    case logout(SettingsTypeAction)
}
