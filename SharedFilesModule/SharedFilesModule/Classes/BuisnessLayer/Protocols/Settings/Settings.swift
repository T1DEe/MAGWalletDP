//
//  Settings.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

// MARK: Конфигурация модуля

public final class Settings {
    public let storage: StorageCore // По примеру любые штуки, которые мы можем вынести и если что менять ECHOLib :)
    public var protectedStorage: StorageCore
    public let network: Network
    public let additionalCurrency: Currency? // Запихнуть токен в модуль.
    //Если модуль не супортит доп валюту, то наверное ничего и не надо делать (пока лучше не придумал)
    
    public typealias BuildConfiguratorClosure = (Configurator) -> Void
    
    public init(build: BuildConfiguratorClosure = { _ in }) {
        let configurator = Configurator()
        build(configurator)
        
        storage = configurator.storage
        protectedStorage = configurator.protectedStorage
        network = configurator.network
        additionalCurrency = configurator.additionalCurrency
    }
}
