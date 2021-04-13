//
//  BTCNetworkAdapterTests.swift
//  BTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import BTCModule

class BTCNetworkAdapterTests: XCTestCase {
    var testnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCNetworkAdapter.self, argument: "TestNet")!
    var mainnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(BTCNetworkAdapter.self, argument: "MainNet")!
    let timeout: TimeInterval = 20
    
    override func setUp() {
        super.setUp()
    }
    
    func testGetTestnetBalance() {
        //arrange
        let address = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        let expect = expectation(description: "testBalance")
        
        //act
        testnetAdapter.balance(address: address) { result in
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
    
    func testGetMainnetBalance() {
        //arrange
        let address = "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe"
        let expect = expectation(description: "testBalance")
        
        //act
        mainnetAdapter.balance(address: address) { result in
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

    func testGetTestnetHistory() {
        //arrange
        let address = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        let skip = 0
        let limit = 10
        let expect = expectation(description: "GetHistory")
        
        //act
        testnetAdapter.history(address: address, skip: skip, limit: limit) { result in
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
    
    func testGetMainnetHistory() {
        //arrange
        let address = "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe"
        let skip = 0
        let limit = 10
        let expect = expectation(description: "GetHistory")

        //act
        mainnetAdapter.history(address: address, skip: skip, limit: limit) { result in
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

    func testUnspentTesnetOutputs() {
        //arrange
        let address = "mojkgACmWsNk185EvkR3vapnehemvdvUPQ"
        let expect = expectation(description: "testUnspentOutputs")

        //act
        testnetAdapter.unspentOutputs(address: address) { result in
            switch result {
            case .success(let outputs):
                //assert
                XCTAssertNotNil(outputs)
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

    func testUnspentMainnetOutputs() {
        //arrange
        let address = "16ftSEQ4ctQFDtVZiUBusQUjRrGhM3JYwe"
        let expect = expectation(description: "testUnspentOutputs")

        //act
        mainnetAdapter.unspentOutputs(address: address) { result in
            switch result {
            case .success(let outputs):
                //assert
                XCTAssertNotNil(outputs)
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
    
    func testGetTestnetFeePerKb() {
        //arrange
        let expect = expectation(description: "testGetFeePerKb")

        //act
        testnetAdapter.getFeePerKb { result in
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
    
    func testGetMainnetFeePerKb() {
        //arrange
        let expect = expectation(description: "testGetFeePerKb")

        //act
        mainnetAdapter.getFeePerKb { result in
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

//    func testSendRowTransaction() {
//        //arrange
//        let transactionHex = "Enter valid transaction hex"
//        let expect = expectation(description: "testSendRowTransaction")
//        testnetAdapter.sendRawTransaction(transactionHex: transactionHex) { result in
//            switch result {
//            case .success:
//                //assert
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
