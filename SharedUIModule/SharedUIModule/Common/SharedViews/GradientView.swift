//
//  GradientView.swift
//  SharedUIModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public class GradientView: UIView {
    public var fromColor: UIColor? {
        didSet {
            configColors()
        }
    }
    
    public var toColor: UIColor? {
        didSet {
            configColors()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    public override func awakeFromNib() {
        configColors()
        
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    private func configColors() {
        let from = fromColor?.cgColor ?? UIColor.clear.cgColor
        let to = toColor?.cgColor ?? UIColor.clear.cgColor
        
        gradientLayer.colors =  [from, to]
    }
}
