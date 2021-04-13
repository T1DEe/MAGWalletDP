//
//  SensitiveDataKeysCoreComponentTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class SensitiveDataKeysCoreComponentTests: XCTestCase {
    var sensitiveDataKeysCoreComponent: SensitiveDataKeysCoreComponent!
    
    override func setUp() {
        super.setUp()
        sensitiveDataKeysCoreComponent = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(SensitiveDataKeysCoreComponent.self)!
    }
    
    func testGenerateSensitiveSeedKey() {
        //arrange
        let wallet = BTCWallet(address: "mhCN4iCe92eiShCLwXhPnmDbKVPUwRbUXa", network: .testnet)
        let expectedKey = "ed9f931bb20d7be39ed35e4e5176e8a2b5331910960f7a932727e45a34ea4188 kseedKey"
        
        //act
        let key = sensitiveDataKeysCoreComponent.generateSensitiveSeedKey(wallet: wallet)
        
        //assert
        XCTAssertEqual(expectedKey, key)

    }
}
