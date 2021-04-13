//
//  BTCTransferServiceTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class BTCTransferServiceTests: XCTestCase {
    var transferService: BTCTransferService!
    var testnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCNetworkAdapter.self, argument: "TestNet")!
    let timeout: TimeInterval = 20
    
    override func setUp() {
        super.setUp()
        transferService = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCTransferService.self)!
    }
    
    func testVerifyAddress() {
        //arrange
        let address = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        
        //act
        let result = transferService.isValidAddress(address)
        
        //assert
        XCTAssertTrue(result)
    }
    
    func testVerifyWrongAddress() {
        //arrange
        let wrongAddress = "mo000000000UPQ"
        
        //act
        let result = transferService.isValidAddress(wrongAddress)
        
        //assert
        XCTAssertFalse(result)
    }
    
    func testTestnetEstimate() {
        transferService.configure(with: .testnet)
        transferService.configure(with: testnetAdapter)

        //arrange
        let address = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        let amount = "1"
        let expect = expectation(description: "testEstimate")

        //act
        transferService.estimate(fromAddress: address, amount: amount) { result in
            switch result {
            case .success(let fee):
                //assert
                XCTAssertNotNil(fee)
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
    
//    func testSendTransaction() {
//        transferService.configure(with: .testnet)
//        transferService.configure(with: testnetAdapter)
//
//        //arrange
//        let seed = "phone client marine that flip have misery alcohol cigar robust immune copper"
//        let address = "mgmcVpSPWToUAV3JQs1rPWyGQbvn6JbRWg"
//        let amount = "1"
//        let expect = expectation(description: "testSendTransaction")
//
//        //act
//        transferService.send(seed: seed, toAddress: address, amount: amount) { result in
//            switch result {
//            case .success:
//                expect.fulfill()
//
//            case .failure:
//                //assert
//                XCTFail()
//            }
//        }
//
//        //assert
//        waitForExpectations(timeout: timeout) { error in
//            XCTAssertNil(error)
//        }
//    }
}

