//
//  QRCodeCoreComponentImp.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public final class QRCodeCoreComponentImp: QRCodeCoreComponent {
    public func generateQRCode(string: String, size: CGSize) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let qrcodeImage = filter.outputImage  else {
            return nil
        }
        
        let backgroundColor = CIColor(cgColor: UIColor.white.withAlphaComponent(0.0).cgColor)
        let foregroundColor = CIColor(cgColor: R.color.dark()?.cgColor ?? UIColor.black.cgColor)
        
        let filterColor = CIFilter(name: "CIFalseColor",
                                   parameters: ["inputImage": qrcodeImage, "inputColor0": foregroundColor, "inputColor1": backgroundColor])
        
        guard let coloredImage = filterColor?.outputImage else {
            return nil
        }
        
        let scaleX = size.width / coloredImage.extent.size.width
        let scaleY = size.height / coloredImage.extent.size.height
        
        let scale = ceil(max(scaleX, scaleY))
        
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        let output = coloredImage.transformed(by: transform)
        
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            return UIImage(ciImage: output)
        }
    }
}
