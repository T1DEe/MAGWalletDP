//
//  ETHAuthauthServiceTest.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

@testable import ETHModule
import XCTest

class ETHAuthServiceTest: XCTestCase {
    let authService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHAuthService.self)!
    
    var currentNetwork: ETHNetworkType?
    
    override func setUp() {
        super.setUp()
        authService.clear()
    }
    
    func testInitialState() {
        //arrange
        let authService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHAuthService.self)!
        
        //act
        let hasWallets = authService.hasWallets

        //assert
        XCTAssertFalse(hasWallets)
    }
    
    func testGetSeed() {
        //arrange
        let seedWordsCount = 12
        
        //act
        let seed = authService.getSeed()
        
        //assert
        XCTAssertEqual(seed.split(separator: " ").count, seedWordsCount)
    }
    
    func testValidSeed() {
        //arrange
        let seed = authService.getSeed()

        //act
        let isValidSeed = authService.verifySeed(seed)
        
        //assert
        XCTAssertTrue(isValidSeed)
    }
    
    func testInvalidSeed() {
        //arrange
        let seedWordsCount = 12
        let seedWordsMaxLenght: UInt32 = 6
        let wrongSeed = (0...seedWordsCount - 1)
            .map { _ in String.randomString(length: Int(arc4random_uniform(seedWordsMaxLenght))) }
            .reduce("", { $0 + " " + $1 })
        
        //act
        let isValidSeed = authService.verifySeed(wrongSeed)
        
        //assert
        XCTAssertFalse(isValidSeed)
    }
    
    func testCreateRandomSeedWallet() {
        authService.configure(with: .rinkeby)
        
        //arrange
        let seed = authService.getSeed()

        //act
        do {
            let currentWallet = try authService.createWallet(seed: seed)
            //assert
            XCTAssertNotNil(currentWallet)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testCreateRandomSeedWalletAndSave() {
        authService.configure(with: .rinkeby)
        
        //arrange
        let seed = authService.getSeed()

        //act
        do {
            let currentWallet = try authService.createWallet(seed: seed)
            try authService.saveWallet(currentWallet, makeCurrent: false)
            //assert
            XCTAssertTrue(authService.hasWallets)
            XCTAssertEqual(try? authService.getWallets().first, currentWallet)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testRegistrationAndThenLogout() {
        authService.configure(with: .rinkeby)
        
        //arrange
        let seed = authService.getSeed()

        //act
        do {
            let currentWallet = try authService.createWallet(seed: seed)
            try authService.saveWallet(currentWallet, makeCurrent: false)
            authService.clear()
            //assert
            XCTAssertFalse(authService.hasWallets)
            XCTAssertNil(try? authService.getWallets())
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testObtainPrivateKeyFromSeed() {
        //arrange
        let seed = authService.getSeed()
        
        //act
        let privateKey = try? authService.obtainPrivateKey(seed: seed)
        
        //assert
        XCTAssertNotNil(privateKey)
    }
    
    func testGetCurrentWallet() {
        authService.configure(with: .rinkeby)
        
        //arrange
        let expectedAddress = "0x049a18016658690D3Ca9CA2A0D201C066E1eDAeF"
        let wallet = ETHWallet(address: expectedAddress, network: .rinkeby)
        try? authService.saveWallet(wallet, makeCurrent: false)
        
        do {
            //act
            let wallet = try authService.getCurrentWallet()
            //assert
            XCTAssertEqual(wallet.address, expectedAddress)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testIsWalletExist() {
        //arrange
        let newAddress = "0x049a18016658690D3Ca9CA2A0D201C066E1eDAeF"
        let newWallet = ETHWallet(address: newAddress, network: .rinkeby)
        
        //act
        let result = authService.isWalletExist(newWallet)
        
        //assert
        XCTAssertFalse(result)
    }
    
    func testSelectWallet() {
        //arrange
        let wallet = ETHWallet(address: "0x049a18016658690D3Ca9CA2A0D201C066E1eDAeF", network: .rinkeby)
        try? authService.saveWallet(wallet, makeCurrent: false)
        
        do {
            //act
            try authService.selectWallet(wallet)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testDeleteWallet() {
        //arrange
        let wallet = ETHWallet(address: "0x049a18016658690D3Ca9CA2A0D201C066E1eDAeF", network: .rinkeby)
        try? authService.saveWallet(wallet, makeCurrent: false)
        
        do {
            //act
            try authService.deleteWallet(wallet)
        } catch {
            //assert
            XCTFail()
        }
    }
}
