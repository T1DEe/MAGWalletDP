//
//  QRCodeCoreComponentTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class QRCodeCoreComponentTests: XCTestCase {
    
    let assembler = ApplicationAssembler.rootAssembler()

    func testGenerateLargeImage() {
        //arrange
        let core = assembler.assembler.resolver.resolve(QRCodeCoreComponent.self)!
        let string = "Hello World!"
        let size = CGSize(width: 1_000, height: 1_000)
        
        //act
        let result = core.generateQRCode(string: string, size: size)
        
        //assert
        XCTAssertNotNil(result)
    }
    
    func testGenerateVeryLargeImage() {
        //arrange
        let core: QRCodeCoreComponent! = assembler.assembler.resolver.resolve(QRCodeCoreComponent.self)
        let string = "Hello World!"
        let size = CGSize(width: 1_0000, height: 1_0000)
        
        //act
        let result = core.generateQRCode(string: string, size: size)
        
        //assert
        XCTAssertNotNil(result)
    }
    
    func testZeroFrameImage() {
        //arrange
        let core = assembler.assembler.resolver.resolve(QRCodeCoreComponent.self)!
        let string = "Hello World!"
        let size = CGSize(width: 0, height: 0)
        
        //act
        let result = core.generateQRCode(string: string, size: size)
        
        //assert
        XCTAssertNotNil(result)
    }
}
