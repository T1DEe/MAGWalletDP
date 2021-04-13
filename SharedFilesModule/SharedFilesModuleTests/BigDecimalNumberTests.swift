//
//  BigDecimalNumberTests.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import SharedFilesModule

class BigDecimalNumberTests: XCTestCase {
    
    
    func testInitExtremumValue() {
        
        //arrange
        
        let stringValue = "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        
        //act
        let bigDoubleString = BigDecimalNumber(stringValue).stringValue
        
        //assert
        XCTAssertEqual(bigDoubleString, stringValue)
    }
    
    func testInitExtremumNegativeValue() {
        
        //arrange
        
        let stringValue = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
        
        //act
        let bigDoubleString = BigDecimalNumber(stringValue).stringValue

        //assert
        XCTAssertEqual(bigDoubleString, stringValue)
    }
    
    func testAddExtremumValue() {
        
        //arrange
        
        let stringValue = "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        let addingValue = "10"
        let expectedResult = "115792089237316195423570985008687907853269984665640564039457584007913129639945"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(addingValue)
        let sum = bDouble1 + bDouble2
        
        
        //assert
        XCTAssertEqual(sum.stringValue, expectedResult)
    }
    
    func testSubExtremumNegativeValue() {
        
        //arrange
        let stringValue = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
        let subValue = "10"
        let expectedResult = "-57896044618658097711785492504343953926634992332820282019728792003956564819976"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(subValue)
        let sum = bDouble1 - bDouble2
        
        //assert
        XCTAssertEqual(sum.stringValue, expectedResult)
    }
    
    func testPowerOfTenNegativeValue() {
        
        //arrange
        let stringValue = "-57896044618658097711785492504343953926634992332820282019728792003956564819966"
        let subValue = "10"
        let expectedResult = "-57896044618658097711785492504343953926634992332820282019728792003956564819976"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(subValue)
        let sum = bDouble1 - bDouble2
        
        //assert
        XCTAssertEqual(sum.stringValue, expectedResult)
    }
    
    func testPowerOfTenValue() {
        
        //arrange
        let stringValue = "9223372036854775807"
        let powerString = "4"
        let expectedResult = "92233720368547758070000"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(powerString)
        let mult = bDouble1.powerOfTen(bDouble2)
        
        //assert
        XCTAssertEqual(mult, expectedResult)
    }
    
    func testPowerOfTenDecimalValue() {
        
        //arrange
        let stringValue = "1.2"
        let powerString = "4"
        let expectedResult = "12000"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(powerString)
        let mult = bDouble1.powerOfTen(bDouble2)
        
        //assert
        XCTAssertEqual(mult, expectedResult)
    }
    
    func testPowerOfTenValue2() {
        
        //arrange
        let stringValue = "9223372036854775807"
        let powerString = "256"
        let expectedResult = "92233720368547758070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(powerString)
        let mult = bDouble1.powerOfTen(bDouble2)
        
        //assert
        XCTAssertEqual(mult, expectedResult)
    }
    
    func testPowerOfTenValue3() {
        
        //arrange
        let stringValue = "9223372036854775807"
        let powerString = "-4"
        let expectedResult = "922337203685477.5807"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(powerString)
        let mult = bDouble1.powerOfTen(bDouble2)
        
        //assert
        XCTAssertEqual(mult, expectedResult)
    }
    
    func testPowerOfTenValue4() {
        
        //arrange
        let stringValue = "1"
        let powerString = "-50"
        let expectedResult = "0.00000000000000000000000000000000000000000000000001"
        
        //act
        let bDouble1 = BigDecimalNumber(stringValue)
        let bDouble2 = BigDecimalNumber(powerString)
        let mult = bDouble1.powerOfTen(bDouble2)
        
        //assert
        XCTAssertEqual(mult, expectedResult)
    }
}
