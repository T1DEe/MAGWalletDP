//
//  ETHSettingsConfiguration.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

public final class ETHSettingsConfiguration: SettingsConfiguration {
    public var isUniqueWallet: Bool = true
    public var isMultiWallet: Bool = false
    public var additionalToken: Currency?
    public var hasAdditionalToken: Bool {
        return additionalToken != nil
    }
    
    public init() {}
}
