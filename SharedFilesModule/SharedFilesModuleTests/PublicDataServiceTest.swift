//
//  PublicDataServiceTest.swift
//  SharedFilesModuleTests
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2019 PixepPlex. All rights reserved.
//

import XCTest
@testable import SharedFilesModule

class PublicDataServiceTest: XCTestCase {
    
    struct CodableMock: Codable, Equatable {
        
        var name: String
        var age: Int
        var array: [String]
        
        static func == (lhs: CodableMock, rhs: CodableMock) -> Bool {
            return lhs.name == rhs.name && lhs.age == rhs.age && lhs.array == rhs.array
        }
    }
    
    func testSharedStoringString() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(PublicDataService.self)!
        let stringKey = "Key"
        let stringValue = "Value"
        
        //act
        try? storage.setPublicData(key: stringKey, data: stringValue)
        let storing = try? storage.obtainPublicData(key: stringKey, type: String.self)
        
        try? storage.removePublicData(key: stringKey)
        let deleted = try? storage.obtainPublicData(key:stringKey, type: String.self)
        
        //assert
        XCTAssertEqual(stringValue, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringObject() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(PublicDataService.self)!
        let objectKey = "ObjectKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        
        //act
        try? storage.setPublicData(key: objectKey, data: objectValue)
        let storing = try? storage.obtainPublicData(key: objectKey, type: CodableMock.self)
        
        try? storage.removePublicData(key: objectKey)
        let deleted = try? storage.obtainPublicData(key: objectKey, type: CodableMock.self)
        
        //assert
        XCTAssertEqual(objectValue, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringArrays() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(PublicDataService.self)!
        let arrayObjectsKey = "arrayObjectsKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let arrayOfObjects = [objectValue, objectValue]
        
        
        //act
        try? storage.setPublicData(key: arrayObjectsKey, data: arrayOfObjects)
        let storing = try? storage.obtainPublicData(key: arrayObjectsKey, type: [CodableMock].self)
        
        try? storage.removePublicData(key: arrayObjectsKey)
        let deleted = try? storage.obtainPublicData(key: arrayObjectsKey, type: [CodableMock].self)
        
        //assert
        XCTAssertEqual(arrayOfObjects, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringDict() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(PublicDataService.self)!
        let dictOfObjectsKey = "dictOfObjectsKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let dictOfObjects = ["key": objectValue]
        
        
        //act
        try? storage.setPublicData(key: dictOfObjectsKey, data: dictOfObjects)
        let storing = try? storage.obtainPublicData(key: dictOfObjectsKey, type: [String: CodableMock].self)
        
        try? storage.removePublicData(key: dictOfObjectsKey)
        let deleted = try? storage.obtainPublicData(key: dictOfObjectsKey, type: [String: CodableMock].self)
        
        //assert
        XCTAssertEqual(dictOfObjects, storing)
        XCTAssertNil(deleted)
    }
    
    func testClear() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(PublicDataService.self)!
        let dictOfObjectsKey1 = "dictOfObjectsKey1"
        let dictOfObjectsKey2 = "dictOfObjectsKey2"
        let dictOfObjectsKey3 = "dictOfObjectsKey3"

        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let dictOfObjects = ["key": objectValue]
        
        
        //act
        try? storage.setPublicData(key: dictOfObjectsKey1, data: dictOfObjects)
        try? storage.setPublicData(key: dictOfObjectsKey2, data: dictOfObjects)
        try? storage.setPublicData(key: dictOfObjectsKey3, data: dictOfObjects)

        storage.clear()
        
        let deleted1 = try? storage.obtainPublicData(key: dictOfObjectsKey1, type: [String: CodableMock].self)
        let deleted2 = try? storage.obtainPublicData(key: dictOfObjectsKey2, type: [String: CodableMock].self)
        let deleted3 = try? storage.obtainPublicData(key: dictOfObjectsKey3, type: [String: CodableMock].self)

        //assert
        XCTAssertNil(deleted1)
        XCTAssertNil(deleted2)
        XCTAssertNil(deleted3)
    }
}

