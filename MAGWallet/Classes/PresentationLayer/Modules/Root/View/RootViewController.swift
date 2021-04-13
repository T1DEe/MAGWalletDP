//
//  RootRootViewController.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    var output: RootViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}
// MARK: - RootViewInput

extension RootViewController: RootViewInput {
    func setupInitialState() { }
}
