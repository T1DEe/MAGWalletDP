//
//  LoaderFooterCell.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Lottie
import UIKit

class LoaderFooterCell: UITableViewCell {
    var loader = AnimationView()
    @IBOutlet weak var loaderContainer: UIView!
    
    override func awakeFromNib() {
        let animation = loader
        loaderContainer.addSubview(animation)
        if let bundle = Bundle(identifier: Constants.bundleIdentifier) {
            let animation = Animation.named(Constants.LottieConstants.grayLoader,
                                            bundle: bundle,
                                            subdirectory: nil,
                                            animationCache: nil)
            
            loader.animation = animation
        }
        animation.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(27)
        }
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.play()
        loaderContainer.backgroundColor = R.color.gray2()
    }
    
    func refreshLoader() {
        loader.play()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        refreshLoader()
    }
}
