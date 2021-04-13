//
//  SensitiveDataService.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule

protocol SensitiveDataService: Clearable {
    func redecryptSensitiveData(newPass: String, oldPass: String) throws
    func obtainSensitiveData(pass: String, key: String) throws -> String
    func setSensitiveData(pass: String, key: String, data: String) throws 
    func removeSensitiveData(key: String) throws
}
