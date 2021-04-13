//
//  AuthRootAuthRootViewController.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class AuthRootViewController: UIViewController {
    var output: AuthRootViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        output.viewDismissed(isMovingFromParent: isMovingFromParent)
    }
}

// MARK: - AuthRootViewInput

extension AuthRootViewController: AuthRootViewInput {
	func setupInitialState() {
  	}
}
