//
//  LTCCoreComponentTests.swift
//  LTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import LTCModule

class LTCCoreComponentTests: XCTestCase {
    var ltcCore: LTCCoreComponent!
    
    override func setUp() {
        super.setUp()
        ltcCore = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(LTCCoreComponent.self)!
    }
    
    func testSeedGeneration() {
        //arrange
        let seedWordsCount = 12
        
        //act
        let seed = try? ltcCore.generateSeed()
        let resultSeedWordsCount = seed?.count
        
        //assert
        XCTAssertEqual(resultSeedWordsCount, seedWordsCount)
    }
    
    func testVerifyRightSeed() {
        //arrange
        let seed = try? ltcCore.generateSeed()
        //act
        let isValidSeed = ltcCore.verifySeed(seed ?? [])
        
        //assert
        XCTAssertTrue(isValidSeed)
    }
    
    func testVerifyWrongSeed() {
        //arrange
        var seed = try? ltcCore.generateSeed()
        seed?.removeLast()
        //act
        let isValidSeed = ltcCore.verifySeed(seed ?? [])
        
        //assert
        XCTAssertFalse(isValidSeed)
    }
    
    func testGetTestnetAddress() {
        //arrange
        let seed = try? ltcCore.generateSeed()
        
        do {
            //act
            let address = try ltcCore.getAddress(seed: seed ?? [], networkType: .testnet)
            //assert
            XCTAssertTrue(address.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testGetMainnetAddress() {
        //arrange
        let seed = try? ltcCore.generateSeed()
        
        do {
            //act
            let address = try ltcCore.getAddress(seed: seed ?? [], networkType: .mainnet)
            //assert
            XCTAssertTrue(address.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testValidTestnetAddress() {
        //arrange
        let seed = ["phone", "client", "marine", "that", "flip", "have", "misery", "alcohol", "cigar", "robust", "immune", "copper"]
        let expectedTestnetAddress = "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS"
        
        do {
            //act
            let address = try ltcCore.getAddress(seed: seed, networkType: .testnet)
            //assert
            XCTAssertEqual(address, expectedTestnetAddress)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testValidMainnetAddress() {
        //arrange
        let seed = ["sweet", "trend", "humble", "soap", "field", "outdoor", "romance", "thumb", "desk", "october", "post", "viable"]
        let expectedMainnetAddress = "LVJFEfeE2nEE8ogWXhGNkocA2T2XN1RGmv"
        
        do {
            //act
            let address = try ltcCore.getAddress(seed: seed, networkType: .mainnet)
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
            let privateKeyData = try ltcCore.getPrivateKeyData(seed: seed, networkType: .mainnet)
            let privateKey = LTCHexFromData(privateKeyData)
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
            let privateKey = try ltcCore.getPrivateKey(seed: seed, networkType: .mainnet)
            //assert
            XCTAssertEqual(privateKey, expectedPrivateKey)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testCreateTransaction() {
        //arrange
        let seed = ["phone", "client", "marine", "that", "flip", "have", "misery", "alcohol", "cigar", "robust", "immune", "copper"]
        let toAddressString = "mgmcVpSPWToUAV3JQs1rPWyGQbvn6JbRWg"
        let changeAddressString = "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS"
        let outputScript = "76a9146398cf3d1b1a9a1157cd092249070ac802d0a00888ac"
        let transactionHash = "9579bbe2e4e17ef036fc6914a0ad7995b6c3870c2861ebd2ea28c2407a3f2179"
        guard let toAddress = LTCAddress(string: toAddressString),
            let changeAddress = LTCAddress(string: changeAddressString) else {
                return
        }

        var outputs: [LTCTransactionOutput] = []
        let txout = LTCTransactionOutput()
        txout.value = LTCAmount(22000)
        txout.script = LTCScript(data: LTCDataFromHex(outputScript))
        txout.transactionHash = LTCDataFromHex(transactionHash)
        txout.index = UInt32(0)
        txout.blockHeight = 1666300
        outputs.append(txout)
        
        let value: LTCAmount = 9000
        let fee: LTCAmount = 1000
        do {
            //act
            let key = try ltcCore.generateKey(seed: seed, networkType: .testnet)
            let transaction = try ltcCore.createTransaction(
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
        let outputScript = "76a9146398cf3d1b1a9a1157cd092249070ac802d0a00888ac"
        let transactionHash = "9579bbe2e4e17ef036fc6914a0ad7995b6c3870c2861ebd2ea28c2407a3f2179"
        
        var outputs: [LTCTransactionOutput] = []
        let txout = LTCTransactionOutput()
        txout.value = LTCAmount(22000)
        txout.script = LTCScript(data: LTCDataFromHex(outputScript))
        txout.transactionHash = LTCDataFromHex(transactionHash)
        txout.index = UInt32(0)
        txout.blockHeight = 1666300
        outputs.append(txout)
        
        do {
            //act
            let fee = try ltcCore.calculateTransactionFee(
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
        let seed = ["phone", "client", "marine", "that", "flip", "have", "misery", "alcohol", "cigar", "robust", "immune", "copper"]
        let toAddressString = "mgmcVpSPWToUAV3JQs1rPWyGQbvn6JbRWg"
        let changeAddressString = "mpbaFSK9QH8cAmBXYs1Bmf4rYA1dQDtgvS"
        let outputScript = "76a9146398cf3d1b1a9a1157cd092249070ac802d0a00888ac"
        let transactionHash = "9579bbe2e4e17ef036fc6914a0ad7995b6c3870c2861ebd2ea28c2407a3f2179"
        guard let toAddress = LTCAddress(string: toAddressString),
            let changeAddress = LTCAddress(string: changeAddressString) else {
                return
        }
        
        var outputs: [LTCTransactionOutput] = []
        let txout = LTCTransactionOutput()
        txout.value = LTCAmount(22000)
        txout.script = LTCScript(data: LTCDataFromHex(outputScript))
        txout.transactionHash = LTCDataFromHex(transactionHash)
        txout.index = UInt32(0)
        txout.blockHeight = 1666300
        outputs.append(txout)
        
        let value: LTCAmount = 9000
        let fee: LTCAmount = 1000
        
        guard let key = try? ltcCore.generateKey(seed: seed, networkType: .testnet) else {
            return
        }
        guard let transaction = try? ltcCore.createTransaction(
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
        let hex = ltcCore.getTransactionHex(transaction: transaction)
        
        //assert
        XCTAssertNotNil(hex)
    }
}
