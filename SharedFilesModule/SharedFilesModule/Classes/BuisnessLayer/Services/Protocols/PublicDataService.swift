//
//  PublicDataService.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol PublicDataService: Clearable {
    func obtainPublicData<T: Codable>(key: String, type: T.Type) throws -> T
    func setPublicData<T: Codable>(key: String, data: T) throws
    func removePublicData(key: String) throws
}
