//
//  ChangeNetworkModel.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public struct ChangeNetworkModel<Value> {
    public var name: String
    public var value: Value
    public var isSelected: Bool
    
    public init(name: String, value: Value, isSelected: Bool) {
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
}

public protocol IdentifiableNetwork {
    var name: String { get }
    
    func isEqual(network: IdentifiableNetwork) -> Bool
}

public extension IdentifiableNetwork {
    func isEqual(network: IdentifiableNetwork) -> Bool {
        return String(reflecting: self) == String(reflecting: network)
    }
}
