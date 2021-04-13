//
//  SensitiveDataKeysCoreComponentTests.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import ETHModule

class SensitiveDataKeysCoreComponentTests: XCTestCase {
    var sensitiveDataKeysCoreComponent: SensitiveDataKeysCoreComponent!
    
    override func setUp() {
        super.setUp()
        sensitiveDataKeysCoreComponent = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(SensitiveDataKeysCoreComponent.self)!
    }
    
    func testGenerateSensitiveSeedKey() {
        //arrange
        let wallet = ETHWallet(address: "0xA0DA7636b47417Fde094D04fC94238AF0333EA2B", network: .rinkeby)
        let expectedKey = "40c6407b1d6e4eb7d16003d1e522161c7709e4d5c4340b460e0793f69dfce246 kseedKey"
        
        //act
        let key = sensitiveDataKeysCoreComponent.generateSensitiveSeedKey(wallet: wallet)
        
        //assert
        XCTAssertEqual(expectedKey, key)

    }
}
