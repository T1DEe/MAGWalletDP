//
//  CryptoNotificationType.swift
//  CryptoAPI
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum CryptoNotificationType: String, Codable {
    case outgoing
    case incoming
    case balance
    case all
}
