//
//  CryptoCoreComponentTest.swift
//  MAGWalletTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import MAGWallet

class CryptoCoreComponentTest: XCTestCase {
    
    let assembler = AppDelegate.applicationAssembler

    func testHashFromEqualString() {
        
        //arrange
        let core = assembler.assembler.resolver.resolve(CryptoCoreComponent.self)!
        let pin1 = "123456"
        let pin2 = "123456"
        
        //act
        let hash1 = core.hash(string: pin1)
        let hash2 = core.hash(string: pin2)
        
        //assert
        XCTAssertEqual(hash1, hash2)
    }
    
    func testHashFromDifferentString() {
        
        //arrange
        let core = assembler.assembler.resolver.resolve(CryptoCoreComponent.self)!
        let pin1 = String.randomString(length: 6)
        let pin2 = String.randomString(length: 6)
        
        //act
        let hash1 = core.hash(string: pin1)
        let hash2 = core.hash(string: pin2)
        
        //assert
        XCTAssertNotEqual(hash1, hash2)
    }
    
    
    func testEncryptPasswordAndDecryptWithSameSalt() {
        
        //arrange
        let core = assembler.assembler.resolver.resolve(CryptoCoreComponent.self)!
        let password = String.randomString(length: 15)
        let salt = String.randomString(length: 6)
        
        //act
        let encrypted = try! core.encrypt(string: password, salt: salt)
        let decrypted = try! core.decrypt(hash: encrypted, salt: salt)
        
        //assert
        XCTAssertEqual(password, decrypted)
    }
    
    func testEncryptPasswordAndDecryptWithDifferentSalt() {
        
        //arrange
        let core = AppDelegate.applicationAssembler.assembler.resolver.resolve(CryptoCoreComponent.self)!
        let password = String.randomString(length: 15)
        let salt = String.randomString(length: 6)
        let anotherSalt = String.randomString(length: 6)

        //act
        let encrypted = try! core.encrypt(string: password, salt: salt)
        let decrypted = try! core.decrypt(hash: encrypted, salt: anotherSalt)
        
        //assert
        XCTAssertNotEqual(password, decrypted)
    }
}
