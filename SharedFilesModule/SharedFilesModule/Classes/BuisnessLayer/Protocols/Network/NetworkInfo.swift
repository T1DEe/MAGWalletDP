//
//  NetworkConfigurable.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public protocol NetworkConfigurable {
    func changeNetwork(network: Network, useDefault: Bool)
}
