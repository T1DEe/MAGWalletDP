//
//  ETHBytecodeComponentTests.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

@testable import ETHModule
import XCTest

class ETHBytecodeComponentTests: XCTestCase {
    
    var core = BytecodeCoreComponentImp()

    func testsSendToken() {
        //arrange
        let result = "0xa9059cbb000000000000000000000000141d5937c7b0e4fb4c535c900c0964b4852007ea00000000000000000000000000000000000000000000000000000002540be400"
        let address = "0x141d5937c7b0e4fb4c535c900c0964b4852007ea"
        let value = "10000000000"
        
        //act
        let bytecode = core.sendTokenBytecode(address: address, value: value)

        //assert
        XCTAssertEqual(result, bytecode)
    }
}
