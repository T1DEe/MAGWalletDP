//
//  KeyValueStoring.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol KeyValueStoring {
    func getData(key: String) -> Data?
    func set(key: String, value: Data)
    func get(key: String) -> String?
    func set(key: String, value: String)
    func remove(key: String)
}
