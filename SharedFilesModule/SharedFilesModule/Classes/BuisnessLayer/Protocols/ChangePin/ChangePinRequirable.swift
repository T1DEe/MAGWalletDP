//
//  ChangePinRequirable.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public typealias ChangePinHandler = () -> Void

public protocol ChangePinRequirable: class {
    var changePinHandler: ChangePinHandler? { get set }
}
