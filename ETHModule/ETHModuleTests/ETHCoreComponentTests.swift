//
//  ETHCoreComponentTests.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

@testable import ETHModule
import XCTest

class ETHCoreComponentTests: XCTestCase {
    let applicationAssembler = ApplicationAssembler.rootAssembler()
    var ethCore: ETHCoreComponent!
    
    override func setUp() {
        super.setUp()
        ethCore = applicationAssembler.assembler.resolver.resolve(ETHCoreComponent.self)
    }
    
    func testsGenerationSeed() {
        //arrange
        let seedWordsCount = 12
        
        //act
        let seed = ethCore.generateSeed()
        let resultSeedWordsCount = seed.split(separator: " ").count

        //assert
        XCTAssertEqual(resultSeedWordsCount, seedWordsCount)
    }
    
    func testsVerifyRightSeed() {
        //arrange
        let seed = ethCore.generateSeed()
        
        //act
        let isValidSeed = ethCore.verifySeed(seed)
        
        //assert
        XCTAssertTrue(isValidSeed)
    }
    
    func testsVerifyWrongSeed() {
        //arrange
        let seedWordsCount = 12
        let seedWordsMaxLenght: UInt32 = 6

        let wrongSeed = (0...seedWordsCount - 1)
            .map { _ in String.randomString(length: Int(arc4random_uniform(seedWordsMaxLenght))) }
            .reduce("", { $0 + " " + $1 })
        
        //act
        let isValidSeed = ethCore.verifySeed(wrongSeed)
        
        //assert
        XCTAssertFalse(isValidSeed)
    }
    
    func testsGenerationKeystore() {
        //arrange
        let seed = ethCore.generateSeed()

        do {
            //act
            _ = try ethCore.createKeystore(seed: seed)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testsGetAddress() {
        //arrange
        let seed = ethCore.generateSeed()
        
        do {
            //act
            let keystore = try ethCore.createKeystore(seed: seed)
            let address = ethCore.getAddress(keystore: keystore)
            //assert
            XCTAssertTrue(address.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testsGetPrivateKey() {
        //arrange
        let seed = ethCore.generateSeed()
        
        do {
            //act
            let keystore = try ethCore.createKeystore(seed: seed)
            let address = ethCore.getAddress(keystore: keystore)
            let privateKey: String = try ethCore.getPrivateKey(keystore: keystore, address: address)
            //assert
            XCTAssertTrue(privateKey.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testsGetTransaction() {
        //arrange
        let seed = ethCore.generateSeed()
        let toAddress = "0x46Ba2677a1c982B329A81f60Cf90fBA2E8CA9fA8"
        let nonce = 100
        let gasPrice = 100
        let gasLimit = 100
        let value = 10
        do {
            //act
            let keystore = try ethCore.createKeystore(seed: seed)
            let address = ethCore.getAddress(keystore: keystore)
            let transaction = try ethCore.createTx(toAddress: toAddress,
                                               fromAddress: address,
                                               keystore: keystore,
                                               nonce: nonce,
                                               gasPrice: gasPrice,
                                               gasLimit: gasLimit,
                                               value: value,
                                               type: .ropsten)
            //assert
            XCTAssertTrue(transaction.count > 0)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testsAddressFormat() {
        //arrange
        let seed = "elevator resource man razor upon cargo three judge ship script ripple track"
        let expectedAddress = "0xC5d46584612D96030D0C7584D76B5136af8462E6"
        do {
            //act
            let keystore = try ethCore.createKeystore(seed: seed)
            let address = ethCore.getAddress(keystore: keystore)
            //assert
            XCTAssertEqual(expectedAddress, address)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testsGetPrivateKeyFormat() {
        //arrange
        let seed = "elevator resource man razor upon cargo three judge ship script ripple track"
        let expectedPrivateKey = "af1e66a2289c3401e4c721e13760c821fb37883457b104ed715bc15a9d1163f9"
        
        do {
            //act
            let keystore = try ethCore.createKeystore(seed: seed)
            let address = ethCore.getAddress(keystore: keystore)
            let privateKey: String = try ethCore.getPrivateKey(keystore: keystore, address: address)
            //assert
            XCTAssertEqual(expectedPrivateKey, privateKey)
        } catch {
            //assert
            XCTFail()
        }
    }
    
    func testsGetPrivateKeyData() {
        //arrange
        let seed = "elevator resource man razor upon cargo three judge ship script ripple track"
        let expectedPrivateKey = "af1e66a2289c3401e4c721e13760c821fb37883457b104ed715bc15a9d1163f9"
        
        do {
            //act
            let keystore = try ethCore.createKeystore(seed: seed)
            let address = ethCore.getAddress(keystore: keystore)
            let privateKey: Data = try ethCore.getPrivateKey(keystore: keystore, address: address)
            //assert
            XCTAssertNotNil(privateKey)
            XCTAssertEqual(expectedPrivateKey, privateKey.hex)
        } catch {
            //assert
            XCTFail()
        }
    }
}
