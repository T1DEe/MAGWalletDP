//
//  HighlightButton.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol HightlightButtonDelegate: NSObjectProtocol {
    func didHighlight(_ button: UIButton)
    func didUnhighlight(_ button: UIButton)
}

class HightlightButton: UIButton {
    weak var delegate: HightlightButtonDelegate?

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                delegate?.didHighlight(self)
            } else {
                delegate?.didUnhighlight(self)
            }
        }
    }
}
