//
//  SnackBarsPresent.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public typealias SnackBarsPresentHandler = (SnackBarPresentable) -> Void

public protocol SnackBarsPresent: class {
    var presentHandler: SnackBarsPresentHandler? { get set }
}
