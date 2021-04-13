//
//  ETHUpdateserviceTests.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

@testable import ETHModule
import SharedFilesModule
import XCTest

class ETHUpdateServiceTests: XCTestCase {
    let updateService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHUpdateService.self)!
    var testnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHNetworkAdapter.self, argument: "Rinkeby")!
    var mainnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHNetworkAdapter.self, argument: "MainNet")!
    
    var currentNetwork: ETHNetworkType?
    let timeout: TimeInterval = 20
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func getWallet() -> ETHWallet {
        let address = "0xA0DA7636b47417Fde094D04fC94238AF0333EA2B"
        let wallet = ETHWallet(address: address, network: .rinkeby)
        return wallet
    }
    
    func getTokenCurrency() -> Currency {
        return Currency(
            id: "0x55616B97B323350d170575BB78Fdf9F078185fa2",
            name: "VSHAR TEST TOKEN",
            symbol: "VSHAR",
            decimals: 2,
            isToken: true
        )
    }
    
    func testUpdateBalance() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let exp = expectation(description: "testUpdateBalance")
        let currency = ETHCurrency.ethCurrency
        //act
        let wallet = getWallet()
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { result in
            do {
                _ = try result.get()
                //assert
                exp.fulfill()
            } catch let error {
                //assert
                XCTFail(error.localizedDescription)
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testUpdateWalletsBalances() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let wallet = getWallet()
        let currency = ETHCurrency.ethCurrency
        let expect = expectation(description: "testUpdateWalletsBalances")
        
        //act
        updateService.updateWalletsBalances(wallets: [wallet], currency: currency) { result in
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
    
    func testTokenBalance() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let exp = expectation(description: "testUpdateBalance")
        let currency = getTokenCurrency()
        
        //act
        let wallet = getWallet()
        updateService.updateWalletBalance(wallet: wallet, currency: currency) { result in
            do {
                _ = try result.get()
                //assert
                exp.fulfill()
            } catch let error {
                //assert
                XCTFail(error.localizedDescription)
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }

    func testObtainHistory() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let exp = expectation(description: "testObtainHistory")
        let from: Int? = nil
        let limit: Int? = 30
        let currency = ETHCurrency.ethCurrency
        //act
        let wallet = getWallet()
        updateService.obtainWalletHistory(wallet: wallet, currency: currency, from: from, limit: limit) { result in
            do {
                let history = try result.get()
                //assert
                XCTAssertTrue(history.data.count > 0)
                exp.fulfill()
            } catch let error {
                //assert
                XCTFail(error.localizedDescription)
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testObtainTokenHistory() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let exp = expectation(description: "testObtainHistory")
        let from: Int? = nil
        let limit: Int? = 30
        let currency = getTokenCurrency()
        
        //act
        let wallet = getWallet()
        updateService.obtainTokenHistory(wallet: wallet, currency: currency, from: from, limit: limit) { result in
            do {
                let history = try result.get()
                //assert
                XCTAssertFalse(history.data.isEmpty)
                exp.fulfill()
            } catch let error {
                //assert
                XCTFail(error.localizedDescription)
            }
        }
        
        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetLocalBalanceFor() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let wallet = ETHWallet(address: "0x049a18016658690D3Ca9CA2A0D201C066E1eDAeF", network: .rinkeby)
        let currency = ETHCurrency.ethCurrency
        
        //act
        let amount = updateService.getLocalBalanceFor(wallet: wallet, currency: currency)
        
        //arrange
        XCTAssertEqual(amount.value, "0")
    }
    
    func testGetLocalBalancesFor() {
        updateService.configure(with: testnetAdapter)
        updateService.configure(with: .rinkeby)
        
        //arrange
        let wallet = ETHWallet(address: "0x049a18016658690D3Ca9CA2A0D201C066E1eDAeF", network: .rinkeby)
        let currency = ETHCurrency.ethCurrency
        
        //act
        let amount = updateService.getLocalBalancesFor(wallets: [wallet], currency: currency)
        
        //arrange
        XCTAssertFalse(amount.isEmpty)
    }
}
