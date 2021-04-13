//
//  OneButtonSnackBarModel.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

struct OneButtonSnackBarModel {
    var isBlocker: Bool
    var title: String
    var buttonTitle: String
    var isError: Bool
    
    init(isBlocker: Bool,
         title: String,
         buttonTitle: String,
         isError: Bool = false) {
        self.isBlocker = isBlocker
        self.title = title
        self.buttonTitle = buttonTitle
        self.isError = isError
    }
}
