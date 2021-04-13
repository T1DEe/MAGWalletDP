//
//  FingerprintAccessService.swift
//  MAGWallet
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation

public enum BiometryType {
    case faceId
    case touchId
    case none
}

public protocol FingerprintAccessService: Clearable {
    var isEnabled: Bool { get }
    var isOn: Bool { get set }
    var biometryType: BiometryType { get }
    
    func fingerprintString(result: @escaping (() throws -> String) -> Void)
    func setFingerprintString(string: String, result: ((() throws -> Void) -> Void)?)
}
