//
//  BTCUpdateServiceTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class BTCUpdateServiceTests: XCTestCase {
    var updateService: BTCUpdateService!
    var testnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCNetworkAdapter.self, argument: "TestNet")!
    var mainnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCNetworkAdapter.self, argument: "MainNet")!
    let timeout: TimeInterval = 20
    
    override func setUp() {
        super.setUp()
        updateService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCUpdateService.self)!
    }
    
    func testUpdateTesnetWalletBalance() {
        updateService.configure(with: .testnet)
        updateService.configure(with: testnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "mvC95EkUUnQX6GXbGpCcmhU5CQBjCtxxcf", network: .testnet)
        let expect = expectation(description: "testUpdateWalletBalance")
        
        //act
        updateService.updateWalletBalance(wallet: wallet) { result in
            switch result {
            case .success(let balance):
                //assert
                XCTAssertNotNil(balance)
                expect.fulfill()
            case .failure:
                //assert
                XCTFail()
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testUpdateMainnetWalletBalance() {
        updateService.configure(with: .mainnet)
        updateService.configure(with: mainnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe", network: .testnet)
        let expect = expectation(description: "testUpdateWalletBalance")
        
        //act
        updateService.updateWalletBalance(wallet: wallet) { result in
            switch result {
            case .success(let balance):
                //assert
                XCTAssertNotNil(balance)
                expect.fulfill()
            case .failure:
                //assert
                XCTFail()
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testUpdateTestnetWalletsBalances() {
        updateService.configure(with: .testnet)
        updateService.configure(with: testnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "mvC95EkUUnQX6GXbGpCcmhU5CQBjCtxxcf", network: .testnet)
        let expect = expectation(description: "testUpdateWalletsBalances")
        
        //act
        updateService.updateWalletsBalances(wallets: [wallet]) { result in
            switch result {
            case .success(let balances):
                //assert
                XCTAssertNotNil(balances)
                expect.fulfill()
            case .failure:
                //assert
                XCTFail()
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testUpdateMainnetWalletsBalances() {
        updateService.configure(with: .mainnet)
        updateService.configure(with: mainnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe", network: .mainnet)
        let expect = expectation(description: "testUpdateWalletsBalances")
        
        //act
        updateService.updateWalletsBalances(wallets: [wallet]) { result in
            switch result {
            case .success(let balances):
                //assert
                XCTAssertNotNil(balances)
                expect.fulfill()
            case .failure:
                //assert
                XCTFail()
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testObtainTestnetWalletHistory() {
        updateService.configure(with: .testnet)
        updateService.configure(with: testnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "mvC95EkUUnQX6GXbGpCcmhU5CQBjCtxxcf", network: .testnet)
        let skip = 0
        let limit = 10
        let expect = expectation(description: "testObtainWalletHistory")
        
        //act
        updateService.obtainWalletHistory(wallet: wallet, skip: skip, limit: limit) { result in
            switch result {
            case .success(let history):
                //assert
                XCTAssertNotNil(history)
                expect.fulfill()
                
            case .failure:
                //assert
                XCTFail()
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testObtainMainnetWalletHistory() {
        updateService.configure(with: .mainnet)
        updateService.configure(with: mainnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe", network: .mainnet)
        let skip = 0
        let limit = 10
        let expect = expectation(description: "testObtainWalletHistory")
        
        //act
        updateService.obtainWalletHistory(wallet: wallet, skip: skip, limit: limit) { result in
            switch result {
            case .success(let history):
                //assert
                XCTAssertNotNil(history)
                expect.fulfill()
                
            case .failure:
                //assert
                XCTFail()
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetLocalBalanceForTestnetWallet() {
        updateService.configure(with: .testnet)
        updateService.configure(with: testnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "mvC95EkUUnQX6GXbGpCcmhU5CQBjCtxxcf", network: .testnet)
        
        //act
        let balance = updateService.getLocalBalanceFor(wallet: wallet)
        
        //arrange
        XCTAssertFalse(balance.isEmpty)
    }
    
    func testGetLocalBalanceForMainnetWallet() {
        updateService.configure(with: .mainnet)
        updateService.configure(with: mainnetAdapter)
        
        //arrange
        let wallet = BTCWallet(address: "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe", network: .mainnet)
        
        //act
        let balance = updateService.getLocalBalanceFor(wallet: wallet)
        
        //arrange
        XCTAssertFalse(balance.isEmpty)
    }
}
