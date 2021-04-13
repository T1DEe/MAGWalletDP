//
//  SensitiveDataKeysCoreComponent.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol SensitiveDataKeysCoreComponent {
    func generateSensitiveSeedKey(wallet: LTCWallet) -> String
}
