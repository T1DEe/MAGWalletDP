//
//  SnackBarTouchableView.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

final class SnackBarTouchableView: UIView {
    var canTapOnView: ((UIView?) -> Bool)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if canTapOnView?(view) == true {
            return view
        } else {
            return nil
        }
    }
}
