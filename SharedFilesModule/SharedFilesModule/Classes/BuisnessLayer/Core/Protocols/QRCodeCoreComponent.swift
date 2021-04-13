//
//  QRCodeService.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

public protocol QRCodeCoreComponent {
    func generateQRCode(string: String, size: CGSize) -> UIImage?
}
