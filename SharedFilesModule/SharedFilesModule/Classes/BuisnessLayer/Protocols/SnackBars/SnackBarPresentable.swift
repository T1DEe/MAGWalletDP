//
//  SnackBarPresentable.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public protocol SnackBarPresentableDelegate: class {
    func dismissSnackBar(snackBar: SnackBarPresentable)
}

public protocol SnackBarPresentable: class {
    var isFullScreen: Bool { get set }
    var needAddSwipeForClose: Bool { get set }
    var snackBarView: UIView { get }
    var snackBarViewController: UIViewController { get }
    var dismissDelegate: SnackBarPresentableDelegate? { get set }
    
    func didDismiss()
}
