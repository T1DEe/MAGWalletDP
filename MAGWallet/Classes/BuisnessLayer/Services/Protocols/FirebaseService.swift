//
//  FirebaseService.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

protocol FirebaseService {
    var token: String? { get set }
    var previousToken: String? { get set }
    
    func configure()
}
