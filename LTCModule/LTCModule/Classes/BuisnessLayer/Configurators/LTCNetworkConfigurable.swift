//
//  LTCNetworkConfigurable.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol LTCNetworkConfigurable {
    func configure(with networkType: LTCNetworkType)
    func configure(with networkAdapter: LTCNetworkAdapter)
}
