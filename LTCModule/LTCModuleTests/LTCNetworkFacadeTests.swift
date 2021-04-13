//
//  LTCNetworkFacadeTests.swift
//  LTCModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import LTCModule

class LTCNetworkFacadeTests: XCTestCase {
    var networkFacade: LTCNetworkFacade!
    
    override func setUp() {
        super.setUp()
        networkFacade = ApplicationAssembler.rootAssembler().assembler.resolver.resolve(LTCNetworkFacade.self)!
    }
    
    func testLoadSavedNetwork() {
        //arrange
        let network: LTCNetworkType = .testnet
        
        //act
        networkFacade.useOnlyDefaultNetwork(false)
        networkFacade.setCurrentNetwork(network: network)
        let savedNetwork = networkFacade.loadSavedNetwork()
        
        //assert
        XCTAssertNotNil(network)
        XCTAssertEqual(savedNetwork, network)
    }
    
    func testUseOnlyDefaultNetwork() {
        //arrange
        let network: LTCNetworkType = .testnet
        let switchNetwork: LTCNetworkType = .mainnet
        
        //act
        networkFacade.useOnlyDefaultNetwork(false)
        networkFacade.setCurrentNetwork(network: network)
        networkFacade.useOnlyDefaultNetwork(true)
        networkFacade.setCurrentNetwork(network: switchNetwork)
        
        let currentNetwork = networkFacade.getCurrentNetwork()
        let usingOnlyDefault = networkFacade.usingOnlyDefaultNetwork()
        
        //assert
        XCTAssertNotEqual(currentNetwork, switchNetwork)
        XCTAssertTrue(usingOnlyDefault)
    }
    
    func testSetCurrentNetwork() {
        //arrange
        let network: LTCNetworkType = .testnet
        
        //act
        networkFacade.useOnlyDefaultNetwork(false)
        networkFacade.setCurrentNetwork(network: network)
        
        let currentNetwork = networkFacade.getCurrentNetwork()
        let savedNetwork = networkFacade.loadSavedNetwork()
        
        //assert
        XCTAssertEqual(currentNetwork, network)
        XCTAssertEqual(savedNetwork, network)
    }
}
