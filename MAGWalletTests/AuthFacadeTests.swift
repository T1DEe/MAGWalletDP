//
//  AuthFacadeTests.swift
//  MAGWalletTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import MAGWallet

class AuthFacadeTests: XCTestCase {
    let facade = AppDelegate.applicationAssembler.assembler.resolver.resolve(AuthFacade.self)!
    
    override func setUp() {
        super.setUp()
        facade.clear()
    }
    
    func testInitialState() {
        //act
        let hashOfPin = facade.hashOfPin
        
        //assert
        XCTAssertNil(hashOfPin)
    }
    
    func testStorePin() {
        //arrange
        let pin = "111111"
        //act
        try? facade.storePin(pin: pin)
        let hashOfPin = facade.hashOfPin
        
        //assert
        XCTAssertNotNil(hashOfPin)
    }
    
    func testStoreVerifyPin() {
        //arrange
        let pin = "111111"
        //act
        try? facade.storePin(pin: pin)
        let result = facade.verify(pin: pin)
        
        //assert
        XCTAssertTrue(result)
    }
    
    func testChangeVerifyPin() {
        //arrange
        let pin = "111111"
        let newPin = "222222"
        
        //act
        try? facade.storePin(pin: pin)
        try? facade.changePin(newPin: newPin, oldPin: pin)
        let result = facade.verify(pin: newPin)
        
        //assert
        XCTAssertTrue(result)
    }
    
    func testClearPin() {
        //arrange
        let pin = "111111"
        
        //act
        try? facade.storePin(pin: pin)
        facade.clear()
        let result = facade.verify(pin: pin)
        
        //assert
        XCTAssertFalse(result)
    }
}
