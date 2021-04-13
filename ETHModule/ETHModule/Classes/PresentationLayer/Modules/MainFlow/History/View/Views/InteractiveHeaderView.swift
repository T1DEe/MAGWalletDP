//
//  InteractiveHeaderView.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import UIKit

class InteractiveHeaderView: UIView {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private var inversed = false
    
    var title: String = "" {
        didSet {
            headerLabel.text = title
        }
    }
    var onTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    private func config() {
        configView()
        configGestureRecognizer()
    }
    
    private func configView() {
        headerLabel.textColor = R.color.gray1()
        headerLabel.font = R.font.poppinsMedium(size: 12)
        imageView.image = R.image.triangle()
    }
    
    private func configGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 1
        addGestureRecognizer(recognizer)
    }
    
    func setDefaultState() {
        if inversed {
            rotateImage()
        }
    }
    
    func setHeaderState() {
        imageView.isHidden = true
        gestureRecognizers?.forEach {
            removeGestureRecognizer($0)
        }
    }
    
    private func degToRad(_ deg: Double) -> Double {
        return deg * .pi / 180
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        onTap?()
        rotateImage()
    }
    
    private func rotateImage() {
        let rotationAngle = degToRad(180)
        let from = inversed ? rotationAngle : 0
        let to = inversed ? 0 : rotationAngle
        
        inversed = !inversed
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = NSNumber(value: from)
        animation.toValue = NSNumber(value: to)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.2
        
        imageView.layer.add(animation, forKey: "rotation")
    }
}
