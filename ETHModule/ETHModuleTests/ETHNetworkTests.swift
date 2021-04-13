//
//  ETHNetworkTests.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

@testable import ETHModule
import XCTest

class ETHNetworkTests: XCTestCase {
    let testnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHNetworkAdapter.self, argument: "Rinkeby")!
    let mainnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHNetworkAdapter.self, argument: "MainNet")!
    let timeout: TimeInterval = 20

    func testGettingTestnetBalance() {
        //arrange
        let address = "0xA0DA7636b47417Fde094D04fC94238AF0333EA2B"
        let exp = expectation(description: "testsBalance")

        //act
        testnetAdapter.balance(address: address) { result in
            do {
                let balance = try result()
                //assert
                XCTAssertNotNil(balance)
                exp.fulfill()
            } catch {
                //assert
                XCTFail()
            }
        }

        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGettingMainnetBalance() {
        //arrange
        let address = "0x1937c5c515057553ccbd46d5866455ce66290284"
        let exp = expectation(description: "testsBalance")

        //act
        mainnetAdapter.balance(address: address) { result in
            do {
                let balance = try result()
                //assert
                XCTAssertNotNil(balance)
                exp.fulfill()
            } catch {
                //assert
                XCTFail()
            }
        }

        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }

    func testGettingTestnetHistory() {
        //arrange
        let address = "0xA0DA7636b47417Fde094D04fC94238AF0333EA2B"
        let exp = expectation(description: "testGettingHistory")

        //act
        testnetAdapter.history(address: address, from: nil, limit: 30) { result in
            do {
                let history = try result()
                //assert
                XCTAssertNotEqual(history.data.count, 0)
                exp.fulfill()
            } catch let error {
                //assert
                print(error)
                XCTFail()
            }
        }

        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGettingMainnetHistory() {
        //arrange
        let address = "0x943d56d95613984e4972ae0c4edf1471502a248e"
        let exp = expectation(description: "testGettingHistory")

        //act
        mainnetAdapter.history(address: address, from: nil, limit: 30) { result in
            do {
                let history = try result()
                //assert
                XCTAssertNotEqual(history.data.count, 0)
                exp.fulfill()
            } catch let error {
                //assert
                print(error)
                XCTFail()
            }
        }

        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }

    func testEstimateGas() {
        //arrange
        let fromAddress = "0xC5d46584612D96030D0C7584D76B5136af8462E6"
        let toAddress = "0xC5d46584612D96030D0C7584D76B5136af8462E6"
        let value = "1"
        let data = ""
        let exp = expectation(description: "testEstimateGas")

        //act
        testnetAdapter.estimateGas(from: fromAddress, to: toAddress, value: value, data: data) { result in
            do {
                let gas = try result()
                //assert
                XCTAssertNotNil(gas)
                exp.fulfill()
            } catch {
                //assert
                XCTFail()
            }
        }

        //assert
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error)
        }
    }
    
//    func testSendRawTransaction() {
//        //arrange
//        let transaction = ""
//        let exp = expectation(description: "testSendRawTransaction")
//
//        //act
//        testnetAdapter.sendRawTransaction(transaction: transaction) { handler in
//            do {
//                let _ = try handler()
//                //assert
//                exp.fulfill()
//            } catch {
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
