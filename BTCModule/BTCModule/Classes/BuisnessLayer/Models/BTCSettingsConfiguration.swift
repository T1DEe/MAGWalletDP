//
//  BTCSettingsConfiguration.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

public final class BTCSettingsConfiguration: SettingsConfiguration {
    public var isUniqueWallet: Bool = true
    public var isMultiWallet: Bool = false
    
    public init() {}
}
