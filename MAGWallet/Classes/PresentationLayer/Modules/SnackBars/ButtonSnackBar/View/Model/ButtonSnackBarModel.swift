//
//  ButtonSnackBarModel.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct ButtonSnackBarModel {
    var isBlocker: Bool
    var isError: Bool
    var title: String
    var message: String
    var leftButtonTitle: String?
    var rightButtonTitle: String?
    var centerButtonTitle: String?

    init(isBlocker: Bool,
         isError: Bool,
         title: String,
         message: String,
         leftButtonTitle: String?,
         rightButtonTitle: String?) {
        self.isBlocker = isBlocker
        self.isError = isError
        self.title = title
        self.message = message
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonTitle = leftButtonTitle
    }

    init(isBlocker: Bool,
         isError: Bool,
         title: String,
         message: String,
         centerButtonTitle: String?) {
        self.isBlocker = isBlocker
        self.isError = isError
        self.title = title
        self.message = message
        self.centerButtonTitle = centerButtonTitle
    }
}
