//
//  BigNumberTest.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import SharedFilesModule
import BigNumber

class BigNumberTest: XCTestCase {

    
    func testInitExtremumValue() {
        
        //arrange

        let stringValue = "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        
        //act
        let bigDoubleString = BDouble(stringValue)?.fractionDescription
        
        //assert
        XCTAssertEqual(bigDoubleString, stringValue)
    }
    
    func testInitExtremumNegativeValue() {
        
        //arrange
        
        let stringValue = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
        
        //act
        let bigDoubleString = BDouble(stringValue)?.fractionDescription
        
        //assert
        XCTAssertEqual(bigDoubleString, stringValue)
    }
    
    func testAddExtremumValue() {
        
        //arrange
        
        let stringValue = "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        let addingValue = "10"
        let expectedResult = "115792089237316195423570985008687907853269984665640564039457584007913129639945"
        
        //act
        let bDouble1 = BDouble(stringValue)!
        let bDouble2 = BDouble(addingValue)!
        let sum = bDouble1 + bDouble2
        
        
        //assert
        XCTAssertEqual(sum.fractionDescription, expectedResult)
    }
    
    func testSubExtremumNegativeValue() {
        
        //arrange
        let stringValue = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
        let subValue = "10"
        let expectedResult = "-57896044618658097711785492504343953926634992332820282019728792003956564819976"
        
        //act
        let bDouble1 = BDouble(stringValue)!
        let bDouble2 = BDouble(subValue)!
        let sum = bDouble1 - bDouble2
        
        
        //assert
        XCTAssertEqual(sum.fractionDescription, expectedResult)
    }
}
