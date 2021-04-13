//
//  SnackBarsEventProxy.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol SnackBarsEventDelegate: class {
    func didPresentSnackBar(_ snackBar: SnackBarPresentable)
}

public protocol SnackBarsEventDelegateHandler: class {
    var delegate: SnackBarsEventDelegate? { get set }
}

public protocol SnackBarsActionHandler {
    func actionPresentSnackBar(_ snackBar: SnackBarPresentable)
}

public protocol SnackBarsEventProxy: SnackBarsActionHandler, SnackBarsEventDelegateHandler {
}
