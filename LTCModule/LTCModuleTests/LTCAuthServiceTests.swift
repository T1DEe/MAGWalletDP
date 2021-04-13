//
//  LTCAuthServiceTests.swift
//  LTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import LTCModule

class LTCAuthServiceTests: XCTestCase {
    var authService: LTCAuthService!

    override func setUp() {
        super.setUp()
        authService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(LTCAuthService.self)!
        try? authService.clear()
    }
    
    func testHasWallets() {
        //act
        let hasWallets = authService.hasWallets

        //assert
        XCTAssertFalse(hasWallets)
    }
    
    func testGetSeed() {
        //arrange
        let seedWordsCount = 12
        var seed: String?
        
        do {
            //act
            seed = try authService.getSeed()
            //assert
            XCTAssertFalse(seed?.isEmpty ?? true)
        } catch {
            //assert
            XCTFail()
        }
        
        //assert
        XCTAssertEqual(seed?.split(separator: " ").count, seedWordsCount)
    }
    
    func testVerifySeed() {
        //arrange
        let seed = "online measure brush blade various flip orphan erosion guard pudding layer near"
        
        //act
        let result = authService.verifySeed(seed)
        
        //assert
        XCTAssertTrue(result)
    }
    
    func testVerifyWrongSeed() {
        //arrange
        let seed = "wrong seed"
        
        //act
        let result = authService.verifySeed(seed)
        
        //assert
        XCTAssertFalse(result)
    }
    
    func testObtainPrivateKey() {
        authService.configure(with: .testnet)
        
        //arrange
        let seed = "online measure brush blade various flip orphan erosion guard pudding layer near"
        
        do {
            //act
            let privateKey = try authService.obtainPrivateKey(seed: seed)
            //assert
            XCTAssertFalse(privateKey.isEmpty)
        } catch {
            //assert
            XCTFail()
        }
        
    }
    
    func testCreateWalletTestnet() {
        authService.configure(with: .testnet)
        
        //arrange
        let seed = "phone client marine that flip have misery alcohol cigar robust immune copper"
        let expectedAddress = "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS"
        do {
            //act
            let wallet = try authService.createWallet(seed: seed)
            //assert
            XCTAssertEqual(wallet.address, expectedAddress)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testCreateWalletMainnet() {
        authService.configure(with: .mainnet)
        
        //arrange
        let seed = "sweet trend humble soap field outdoor romance thumb desk october post viable"
        let expectedAddress = "LVJFEfeE2nEE8ogWXhGNkocA2T2XN1RGmv"
        do {
            //act
            let wallet = try authService.createWallet(seed: seed)
            //assert
            XCTAssertEqual(wallet.address, expectedAddress)
        } catch {
            //assert
            XCTFail()
        }
    }

    func testGetMainnetWallets() {
        authService.configure(with: .mainnet)
        
        //arrange
        let testnetWallet = LTCWallet(address: "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS", network: .testnet)
        try? authService.saveWallet(testnetWallet, makeCurrent: false)
        let mainnetWallet = LTCWallet(address: "LVJFEfeE2nEE8ogWXhGNkocA2T2XN1RGmv", network: .mainnet)
        try? authService.saveWallet(mainnetWallet, makeCurrent: false)
        
        do {
            //act
            let wallets = try authService.getWallets()
            //assert
            XCTAssertEqual(wallets.count, 1)
            XCTAssertEqual(mainnetWallet, wallets.first)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testGetTestnetWallets() {
        authService.configure(with: .mainnet)
        
        //arrange
        let testnetWallet = LTCWallet(address: "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS", network: .testnet)
        try? authService.saveWallet(testnetWallet, makeCurrent: false)
        let mainnetWallet = LTCWallet(address: "LVJFEfeE2nEE8ogWXhGNkocA2T2XN1RGmv", network: .mainnet)
        try? authService.saveWallet(mainnetWallet, makeCurrent: false)
        
        do {
            //act
            let wallets = try authService.getWallets()
            //assert
            XCTAssertEqual(wallets.count, 1)
            XCTAssertEqual(mainnetWallet, wallets.first)
        } catch {
            //assert
            XCTFail()
        }
    }

    func testGetCurrentMainnetWallet() {
        authService.configure(with: .mainnet)
        
        //arrange
        let expectedAddress = "LVJFEfeE2nEE8ogWXhGNkocA2T2XN1RGmv"
        let address = "LSA4FhTFHMAex798pXdYSZbD4tGwBFuReF"
        
        let firstWallet = LTCWallet(address: address, network: .mainnet)
        try? authService.saveWallet(firstWallet, makeCurrent: true)
        let secondWallet = LTCWallet(address: expectedAddress, network: .mainnet)
        try? authService.saveWallet(secondWallet, makeCurrent: true)
        
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
    
    func testGetCurrentTestnetWallet() {
        authService.configure(with: .testnet)
        
        //arrange
        let expectedAddress = "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS"
        let address = "mgmcVpSPWToUAV3JQs1rPWyGQbvn6JbRWg"
        
        let firstWallet = LTCWallet(address: address, network: .testnet)
        try? authService.saveWallet(firstWallet, makeCurrent: true)
        let secondWallet = LTCWallet(address: expectedAddress, network: .testnet)
        try? authService.saveWallet(secondWallet, makeCurrent: true)
        
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
        let testnetAddress = "mgmcVpSPWToUAV3JQs1rPWyGQbvn6JbRWg"
        let testnetWallet = LTCWallet(address: testnetAddress, network: .testnet)
        let mainnetAddress = "LSA4FhTFHMAex798pXdYSZbD4tGwBFuReF"
        let mainnetWallet = LTCWallet(address: mainnetAddress, network: .mainnet)

        //act
        let mainnetResult = authService.isWalletExist(testnetWallet)
        let testnetResult = authService.isWalletExist(mainnetWallet)

        //assert
        XCTAssertFalse(mainnetResult)
        XCTAssertFalse(testnetResult)
    }

    func testSaveWallet() {
        //arrange
        let mainnetWallet = LTCWallet(address: "LSA4FhTFHMAex798pXdYSZbD4tGwBFuReF", network: .mainnet)
        let testnetWallet = LTCWallet(address: "mgmcVpSPWToUAV3JQs1rPWyGQbvn6JbRWg", network: .testnet)

        do {
            //act
            try authService.saveWallet(mainnetWallet, makeCurrent: true)
            try authService.saveWallet(testnetWallet, makeCurrent: true)
        } catch {
            //assert
            XCTFail()
        }
    }

    func testSelectWallet() {
        //arrange
        let wallet = LTCWallet(address: "LSA4FhTFHMAex798pXdYSZbD4tGwBFuReF", network: .mainnet)
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
        let wallet = LTCWallet(address: "LSA4FhTFHMAex798pXdYSZbD4tGwBFuReF", network: .mainnet)
        try? authService.saveWallet(wallet, makeCurrent: false)

        do {
            //act
            try authService.deleteWallet(wallet)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testClear() {
        do {
            //act
            try authService.clear()
        } catch {
            //assert
            XCTFail()
        }
    }
    
}
