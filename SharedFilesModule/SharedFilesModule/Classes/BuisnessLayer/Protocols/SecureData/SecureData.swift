//
//  SecureData.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public typealias SecureDataProcessCommandHandler = (_ command: SecureDataCommand) -> Void

public protocol SecureData: class {
    var processCommandHandler: SecureDataProcessCommandHandler? { get set }
}
