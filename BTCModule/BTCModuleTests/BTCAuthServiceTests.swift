//
//  BTCAuthServiceTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class BTCAuthServiceTests: XCTestCase {
    var authService: BTCAuthService!

    override func setUp() {
        super.setUp()
        authService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCAuthService.self)!
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
        let seed = "pumpkin capable blame famous warm rich there army connect duty charge gauge"
        let expectedAddress = "mwyCfmxhXzx2WKBZDeXoggF3MM2EoVMSMP"
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
        let seed = "oppose gorilla credit wedding sphere pattern denial result tower lion milk depth"
        let expectedAddress = "1DU7CyMGRbNz3J8byMNpVgeDJXgBJjRzuK"
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
        let testnetWallet = BTCWallet(address: "mwyCfmxhXzx2WKBZDeXoggF3MM2EoVMSMP", network: .testnet)
        try? authService.saveWallet(testnetWallet, makeCurrent: false)
        let mainnetWallet = BTCWallet(address: "1DU7CyMGRbNz3J8byMNpVgeDJXgBJjRzuK", network: .mainnet)
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
        let testnetWallet = BTCWallet(address: "mwyCfmxhXzx2WKBZDeXoggF3MM2EoVMSMP", network: .testnet)
        try? authService.saveWallet(testnetWallet, makeCurrent: false)
        let mainnetWallet = BTCWallet(address: "1DU7CyMGRbNz3J8byMNpVgeDJXgBJjRzuK", network: .mainnet)
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
        let expectedAddress = "1DU7CyMGRbNz3J8byMNpVgeDJXgBJjRzuK"
        let address = "1DszwdqEEsZcNw6SrrC5D25Uv7XwuYfpCi"
        
        let firstWallet = BTCWallet(address: address, network: .mainnet)
        try? authService.saveWallet(firstWallet, makeCurrent: true)
        let secondWallet = BTCWallet(address: expectedAddress, network: .mainnet)
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
        let expectedAddress = "mwyCfmxhXzx2WKBZDeXoggF3MM2EoVMSMP"
        let address = "mjpwQvyTAMC1Dozf3UScee46oEvEYyRG6e"
        
        let firstWallet = BTCWallet(address: address, network: .testnet)
        try? authService.saveWallet(firstWallet, makeCurrent: true)
        let secondWallet = BTCWallet(address: expectedAddress, network: .testnet)
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
        let testnetAddress = "mwyCfmxhXzx2WKBZDeXoggF3MM2EoVMSMP"
        let testnetWallet = BTCWallet(address: testnetAddress, network: .testnet)
        let mainnetAddress = "1DszwdqEEsZcNw6SrrC5D25Uv7XwuYfpCi"
        let mainnetWallet = BTCWallet(address: mainnetAddress, network: .mainnet)

        //act
        let mainnetResult = authService.isWalletExist(testnetWallet)
        let testnetResult = authService.isWalletExist(mainnetWallet)

        //assert
        XCTAssertFalse(mainnetResult)
        XCTAssertFalse(testnetResult)
    }

    func testSaveWallet() {
        //arrange
        let mainnetWallet = BTCWallet(address: "1DszwdqEEsZcNw6SrrC5D25Uv7XwuYfpCi", network: .mainnet)
        let testnetWallet = BTCWallet(address: "mwyCfmxhXzx2WKBZDeXoggF3MM2EoVMSMP", network: .testnet)

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
        let wallet = BTCWallet(address: "1DszwdqEEsZcNw6SrrC5D25Uv7XwuYfpCi", network: .mainnet)
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
        let wallet = BTCWallet(address: "1DszwdqEEsZcNw6SrrC5D25Uv7XwuYfpCi", network: .mainnet)
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
