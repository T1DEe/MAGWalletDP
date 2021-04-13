//
//  SnackBarRootOutputModel.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import SharedFilesModule
import UIKit

class SnackBarRootModel {
    var snackBarPresentableModel: SnackBarPresentable
    var snackBarViewController: UIViewController
    var snackBarView: UIView
    var shouldShowAnimated: Bool
    
    init(snackBarPresentableModel: SnackBarPresentable, snackBarViewController: UIViewController, snackBarView: UIView, shouldShowAnimated: Bool) {
        self.snackBarPresentableModel = snackBarPresentableModel
        self.snackBarViewController = snackBarViewController
        self.snackBarView = snackBarView
        self.shouldShowAnimated = shouldShowAnimated
    }
}
