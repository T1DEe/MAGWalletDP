//
//  LTCSettingsConfiguration.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

public final class LTCSettingsConfiguration: SettingsConfiguration {
    public var isMultiWallet: Bool = false
    public var isUniqueWallet: Bool = true
    
    public init() {}
}
