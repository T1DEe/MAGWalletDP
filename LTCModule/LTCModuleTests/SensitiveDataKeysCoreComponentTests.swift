//
//  SensitiveDataKeysCoreComponentTests.swift
//  LTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import LTCModule

class SensitiveDataKeysCoreComponentTests: XCTestCase {
    var sensitiveDataKeysCoreComponent: SensitiveDataKeysCoreComponent!
    
    override func setUp() {
        super.setUp()
        sensitiveDataKeysCoreComponent = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(SensitiveDataKeysCoreComponent.self)!
    }
    
    func testGenerateSensitiveSeedKey() {
        //arrange
        let wallet = LTCWallet(address: "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS", network: .testnet)
        let expectedKey = "b6f46900b041c7590a83e6590b68a53c50eabb76fe8fbc221eeb196078d10f2c kseedKey"
        
        //act
        let key = sensitiveDataKeysCoreComponent.generateSensitiveSeedKey(wallet: wallet)
        
        //assert
        XCTAssertEqual(expectedKey, key)

    }
}
