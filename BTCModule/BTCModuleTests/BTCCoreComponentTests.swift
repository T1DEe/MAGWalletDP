//
//  BTCCoreComponentTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class BTCCoreComponentTests: XCTestCase {
    var btcCore: BTCCoreComponent!
    
    override func setUp() {
        super.setUp()
        btcCore = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCCoreComponent.self)!
    }
    
    func testSeedGeneration() {
        //arrange
        let seedWordsCount = 12
        
        //act
        let seed = try? btcCore.generateSeed()
        let resultSeedWordsCount = seed?.count
        
        //assert
        XCTAssertEqual(resultSeedWordsCount, seedWordsCount)
    }
    
    func testVerifyRightSeed() {
        //arrange
        let seed = try? btcCore.generateSeed()
        //act
        let isValidSeed = btcCore.verifySeed(seed ?? [])
        
        //assert
        XCTAssertTrue(isValidSeed)
    }
    
    func testVerifyWrongSeed() {
        //arrange
        var seed = try? btcCore.generateSeed()
        seed?.removeLast()
        //act
        let isValidSeed = btcCore.verifySeed(seed ?? [])
        
        //assert
        XCTAssertFalse(isValidSeed)
    }
    
    func testGetTestnetAddress() {
        //arrange
        let seed = try? btcCore.generateSeed()
        
        do {
            //act
            let address = try btcCore.getAddress(seed: seed ?? [], networkType: .testnet)
            //assert
            XCTAssertTrue(address.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testGetMainnetAddress() {
        //arrange
        let seed = try? btcCore.generateSeed()
        
        do {
            //act
            let address = try btcCore.getAddress(seed: seed ?? [], networkType: .mainnet)
            //assert
            XCTAssertTrue(address.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testValidTestnetAddress() {
        //arrange
        let seed = ["exhibit", "assume", "foil", "setup", "annual", "token", "roof", "spray", "fuel", "laugh", "typical", "leave"]
        let expectedTestnetAddress = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        
        do {
            //act
            let address = try btcCore.getAddress(seed: seed, networkType: .testnet)
            //assert
            XCTAssertEqual(address, expectedTestnetAddress)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testValidMainnetAddress() {
        //arrange
        let seed = ["exhibit", "assume", "foil", "setup", "annual", "token", "roof", "spray", "fuel", "laugh", "typical", "leave"]
        let expectedMainnetAddress = "1NAZfiHtXyUMNUa6tmmn5MLgNofPJSABJr"
        
        do {
            //act
            let address = try btcCore.getAddress(seed: seed, networkType: .mainnet)
            //assert
            XCTAssertEqual(address, expectedMainnetAddress)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testGetPrivateKeyData() {
        //arrange
        let seed = ["exhibit", "assume", "foil", "setup", "annual", "token", "roof", "spray", "fuel", "laugh", "typical", "leave"]
        let expectedPrivateKey = "417a8fa6c6e54e31a5fe79644189a95310ead631b10c7b805d54ea05a6211ee8"
        
        do {
            //act
            let privateKeyData = try btcCore.getPrivateKeyData(seed: seed, networkType: .mainnet)
            let privateKey = BTCHexFromData(privateKeyData)
            //assert
            XCTAssertNotNil(privateKeyData)
            XCTAssertEqual(privateKey, expectedPrivateKey)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testGetPrivateKey() {
        //arrange
        let seed = ["exhibit", "assume", "foil", "setup", "annual", "token", "roof", "spray", "fuel", "laugh", "typical", "leave"]
        let expectedPrivateKey = "417a8fa6c6e54e31a5fe79644189a95310ead631b10c7b805d54ea05a6211ee8"
        
        do {
            //act
            let privateKey = try btcCore.getPrivateKey(seed: seed, networkType: .mainnet)
            //assert
            XCTAssertEqual(privateKey, expectedPrivateKey)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testCreateTransaction() {
        //arrange
        let seed = ["exhibit", "assume", "foil", "setup", "annual", "token", "roof", "spray", "fuel", "laugh", "typical", "leave"]
        let toAddressString = "mjTXbyDS41qWNNkvXi8H5UgmMgTzrdMh7C"
        let changeAddressString = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        let outputScript = "76a9145a2cb6fefabc630e00d2bba1a5d466169b2214ea88ac"
        let transactionHash = "2d2fa4b674a8bd20d3cd1c7ae1aec1af6cd6536fbbd6ae2a5f753083c71c1233"
        guard let toAddress = BTCAddress(string: toAddressString),
            let changeAddress = BTCAddress(string: changeAddressString) else {
                return
        }

        var outputs: [BTCTransactionOutput] = []
        let txout = BTCTransactionOutput()
        txout.value = BTCAmount(22000)
        txout.script = BTCScript(data: BTCDataFromHex(outputScript))
        txout.transactionHash = BTCDataFromHex(transactionHash)
        txout.index = UInt32(0)
        txout.blockHeight = 1666300
        outputs.append(txout)
        
        let value: BTCAmount = 9000
        let fee: BTCAmount = 1000
        do {
            //act
            let key = try btcCore.generateKey(seed: seed, networkType: .testnet)
            let transaction = try btcCore.createTransaction(
                privateKey: key,
                outputs: outputs,
                changeAddress: changeAddress,
                toAddress: toAddress,
                value: value,
                fee: fee,
                checkSignature: true
            )
            //assert
            XCTAssertTrue(transaction?.data.count != 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testCalculateTransactionFee() {
        //arrange
        let amount = 9000
        let feePerKb = 1000
        let outputScript = "76a9145a2cb6fefabc630e00d2bba1a5d466169b2214ea88ac"
        let transactionHash = "2d2fa4b674a8bd20d3cd1c7ae1aec1af6cd6536fbbd6ae2a5f753083c71c1233"
        
        var outputs: [BTCTransactionOutput] = []
        let txout = BTCTransactionOutput()
        txout.value = BTCAmount(22000)
        txout.script = BTCScript(data: BTCDataFromHex(outputScript))
        txout.transactionHash = BTCDataFromHex(transactionHash)
        txout.index = UInt32(0)
        txout.blockHeight = 1666300
        outputs.append(txout)
        
        do {
            //act
            let fee = try btcCore.calculateTransactionFee(
                amount: amount,
                feePerKb: feePerKb,
                unspentOutputs: outputs,
                networkType: .testnet
            )
            //assert
            XCTAssert(fee != 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testGetTransactionHex() {
        //arrange
        let seed = ["exhibit", "assume", "foil", "setup", "annual", "token", "roof", "spray", "fuel", "laugh", "typical", "leave"]
        let toAddressString = "mjTXbyDS41qWNNkvXi8H5UgmMgTzrdMh7C"
        let changeAddressString = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        let outputScript = "76a9145a2cb6fefabc630e00d2bba1a5d466169b2214ea88ac"
        let transactionHash = "2d2fa4b674a8bd20d3cd1c7ae1aec1af6cd6536fbbd6ae2a5f753083c71c1233"
        guard let toAddress = BTCAddress(string: toAddressString),
            let changeAddress = BTCAddress(string: changeAddressString) else {
                return
        }
        
        var outputs: [BTCTransactionOutput] = []
        let txout = BTCTransactionOutput()
        txout.value = BTCAmount(22000)
        txout.script = BTCScript(data: BTCDataFromHex(outputScript))
        txout.transactionHash = BTCDataFromHex(transactionHash)
        txout.index = UInt32(0)
        txout.blockHeight = 1666300
        outputs.append(txout)
        
        let value: BTCAmount = 9000
        let fee: BTCAmount = 1000
        
        guard let key = try? btcCore.generateKey(seed: seed, networkType: .testnet) else {
            return
        }
        guard let transaction = try? btcCore.createTransaction(
            privateKey: key,
            outputs: outputs,
            changeAddress: changeAddress,
            toAddress: toAddress,
            value: value,
            fee: fee,
            checkSignature: true
        ) else {
            return
        }
        
        //act
        let hex = btcCore.getTransactionHex(transaction: transaction)
        
        //assert
        XCTAssertNotNil(hex)
    }
}
