//
//  FirebaseConfigurator.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Firebase

class FirebaseConfigurator: ConfiguratorProtocol {
    var firebaseService: FirebaseService!
    
    func configure() {
        firebaseService.configure()
    }
}
