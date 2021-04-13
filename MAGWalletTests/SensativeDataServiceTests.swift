//
//  SensativeDataServiceTests.swift
//  MAGWalletTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import MAGWallet

class SensativeDataServiceTests: XCTestCase {
    let service = AppDelegate.applicationAssembler.assembler.resolver.resolve(SensitiveDataService.self)!
    
    override func setUp() {
        super.setUp()
        service.clear()
    }
    
    func testSetSensativeData() {
        //arrange
        let value = "someValue"
        let key = "someKey"
        let pass = "somePassword"
        
        //act
        do {
            try service.setSensitiveData(pass: pass, key: key, data: value)
            let storedValue = try service.obtainSensitiveData(pass: pass, key: key)
            
            //assert
            XCTAssertEqual(storedValue, value)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetSensativeDataWrongPass() {
        //arrange
        let value = "someValue"
        let key = "someKey"
        let pass = "somePassword"
        let wrongPass = "wrongPass"
        
        //act
        do {
            try service.setSensitiveData(pass: pass, key: key, data: value)
            let result = try service.obtainSensitiveData(pass: wrongPass, key: key)
            
            //assert
            XCTAssertNotEqual(result, value)
        } catch let error {
            //assert
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRemoveSensativeDataWrongPass() {
        //arrange
        let value = "someValue"
        let key = "someKey"
        let pass = "somePassword"
        let wrongPass = "wrongPass"
        
        //act
        do {
            try service.setSensitiveData(pass: pass, key: key, data: value)
            try service.removeSensitiveData(key: key)
            let _ = try service.obtainSensitiveData(pass: wrongPass, key: key)
            
            //assert
            XCTFail()
        } catch { }
    }
    
    func testRedecryptSensativeDataWrongPass() {
        //arrange
        let value = "someValue"
        let key = "someKey"
        let pass = "somePassword"
        let newPass = "newPass"
        
        //act
        do {
            try service.setSensitiveData(pass: pass, key: key, data: value)
            try service.redecryptSensitiveData(newPass: newPass, oldPass: pass)
            let resultNew = try service.obtainSensitiveData(pass: newPass, key: key)
            let resultOld = try service.obtainSensitiveData(pass: pass, key: key)

            //assert
            XCTAssertNotEqual(resultOld, value)
            XCTAssertNotEqual(resultOld, resultNew)
            XCTAssertEqual(resultNew, value)
        } catch let error {
            //assert
            XCTFail(error.localizedDescription)
        }
    }
}
    
