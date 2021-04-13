//
//  ETHNetworkConfigurable.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol ETHNetworkConfigurable {
    func configure(with networkType: ETHNetworkType)
    func configure(with networkAdapter: ETHNetworkAdapter)
}
