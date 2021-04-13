//
//  ETHTransferTests.swift
//  ETHModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

@testable import ETHModule
import SharedFilesModule
import XCTest

class ETHTransferTests: XCTestCase {
    let timeout: TimeInterval = 20
    var testnetAdapter = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHNetworkAdapter.self, argument: "Rinkeby")!
    
//    func testSendTransaction() {
//        //arrange
//        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
//        service.configure(with: testnetAdapter)
//        service.configure(with: .rinkeby)
//
//        let exp = expectation(description: "testSendTransaction")
//        let seed = "vanish slot puzzle fruit empty theme between fan clerk prize govern drop"
//        let currency = ETHCurrency.ethCurrency
//        let amount = "21000"
//
//        //act
//        service.send(seed: seed, toAddress: "0x559A76740ADFdf009a9A302d1fEa4052620F8569", amount: amount, currency: currency) { result in
//            do {
//                _ = try result.get()
//                //assert
//                exp.fulfill()
//            } catch let error {
//                //assert
//                XCTFail(error.localizedDescription)
//            }
//        }
//
//        //assert
//        waitForExpectations(timeout: timeout) { error in
//            XCTAssertNil(error)
//        }
//    }
//
//    func testSendTokenTransaction() {
//        //arrange
//        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
//        service.configure(with: testnetAdapter)
//        service.configure(with: .rinkeby)
//
//        let exp = expectation(description: "testSendTokenTransaction")
//        let seed = "fiscal caution awful century lemon tomato rotate discover thank poverty tired address"
//        let toAddress = "0xf36c145eff2771ea22ece5fd87392fc8eeae719c"
//        let amount = "1"
//        let currency = Currency(id: "0xf36c145eff2771ea22ece5fd87392fc8eeae719c",
//                                name: "DIM",
//                                symbol: "DIM",
//                                decimals: 10,
//                                isToken: true)
//        //act
//        service.send(seed: seed, toAddress: toAddress, amount: amount, currency: currency) { result in
//            do {
//                _ = try result.get()
//                //assert
//                exp.fulfill()
//            } catch let error {
//                //assert
//                XCTFail(error.localizedDescription)
//            }
//        }
//
//        //assert
//        waitForExpectations(timeout: timeout) { error in
//            XCTAssertNil(error)
//        }
//    }
    
    func testEstimateTransaction() {
        //arrange
        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
        service.configure(with: testnetAdapter)
        service.configure(with: .rinkeby)
        
        let exp = expectation(description: "testEstimateTransaction")
        let fromAddress = "0x141d5937C7b0e4fB4C535c900C0964B4852007eA"
        let toAddress = "0xb0202eBbF797Dd61A3b28d5E82fbA2523edc1a9B"
        let amount = "10"
        let currency = ETHCurrency.ethCurrency
        //act
        service.estimate(fromAddress: fromAddress, toAddress: toAddress, amount: amount, currency: currency) { result in
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
    
    func testEstimateTokenTransaction() {
        //arrange
        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
        service.configure(with: testnetAdapter)
        service.configure(with: .rinkeby)
        
        let exp = expectation(description: "testEstimateTransaction")
        let fromAddress = "0x141d5937C7b0e4fB4C535c900C0964B4852007eA"
        let toAddress = "0xf36c145eff2771ea22ece5fd87392fc8eeae719c"
        let amount = "0"
        let currency = Currency(id: "0xf36c145eff2771ea22ece5fd87392fc8eeae719c",
                                name: "DIM",
                                symbol: "DIM",
                                decimals: 10,
                                isToken: true)
        //act
        service.estimate(fromAddress: fromAddress, toAddress: toAddress, amount: amount, currency: currency) { result in
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
    
    func testAddressValidation1() {
        //arrange
        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
        let address = "0xb0202eBbF797Dd61A3b28d5E82fbA2523edc1a9B"

        //act
        let isValid = service.isValidAddress(address)
        
        //assert
        XCTAssertTrue(isValid)
    }
    
    func testTokenAddressValidation() {
        //arrange
        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
        let address = "0xf36c145eff2771ea22ece5fd87392fc8eeae719c"

        //act
        let isValid = service.isValidAddress(address)
        
        //assert
        XCTAssertTrue(isValid)
    }
    
    
    func testAddressValidation2() {
        //arrange
        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
        let address = "0000"

        //act
        let isValid = service.isValidAddress(address)
        
        //assert
        XCTAssertFalse(isValid)
    }
    
    func testAddressValidation3() {
        //arrange
        let service = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(ETHTransferService.self)!
        let address = "202eBbF797Dd61A3b28d5E82fbA2523edc1a9B"

        //act
        let isValid = service.isValidAddress(address)
        
        //assert
        XCTAssertFalse(isValid)
    }
}
