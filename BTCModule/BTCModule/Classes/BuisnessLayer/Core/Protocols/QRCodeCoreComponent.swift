//
//  QRCodeCoreComponent.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

protocol QRCodeCoreComponent {
    func generateQRCode(string: String, size: CGSize) -> UIImage?
}
