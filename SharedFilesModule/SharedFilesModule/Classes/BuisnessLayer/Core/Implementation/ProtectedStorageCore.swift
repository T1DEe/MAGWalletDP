//
//  ProtectedStorageCore.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

// MARK: Для общения с защищенным хранилищем чезез пин (походу не прокатит так как StorageCore чуток иначе получается)
// возможно надо моменять на подобие взяимодействия с флоу работы валюты. пока чуток хз

public final class ProtectedStorageCore: StorageCore {
    public var storage: KeyValueStoring = ProtectedStorage()
}
