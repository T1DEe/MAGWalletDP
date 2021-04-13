//
//  KeyValueStoring.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol KeyValueStoring {
    func getData(key: String) -> Data?
    func set(key: String, value: Data) throws
    func get(key: String) -> String?
    func set(key: String, value: String) throws
    func remove(key: String)
}
