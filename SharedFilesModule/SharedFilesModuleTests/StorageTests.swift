//
//  StorageTests.swift
//  SharedFilesModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import XCTest
@testable import SharedFilesModule

class StorageTests: XCTestCase {
    
    struct CodableMock: Codable, Equatable {
        
        var name: String
        var age: Int
        var array: [String]
        
        static func == (lhs: CodableMock, rhs: CodableMock) -> Bool {
            return lhs.name == rhs.name && lhs.age == rhs.age && lhs.array == rhs.array
        }
    }
    
    func testRAMStoringString() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "RAM")!
        let stringKey = "Key"
        let stringValue = "Value"
        
        //act
        try? storage.set(key: stringKey, value: stringValue)
        let storing = storage.get(key:stringKey)
        
        storage.remove(key: stringKey)
        let deleted = storage.get(key:stringKey)
        
        //assert
        XCTAssertEqual(stringValue, storing)
        XCTAssertNil(deleted)
    }

    func testRAMStoringObject() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "RAM")!
        let objectKey = "ObjectKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])

        //act
        try? storage.set(key: objectKey, value: objectValue)
        let storing = storage.get(key: objectKey, type: CodableMock.self)
        
        storage.remove(key: objectKey)
        let deleted = storage.get(key: objectKey)
        
        //assert
        XCTAssertEqual(objectValue, storing)
        XCTAssertNil(deleted)
    }
    
    func testRAMStoringArrays() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "RAM")!
        let arrayObjectsKey = "arrayObjectsKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let arrayOfObjects = [objectValue, objectValue]

        
        //act
        try? storage.set(key: arrayObjectsKey, value: arrayOfObjects)
        let storing = storage.get(key: arrayObjectsKey, type: [CodableMock].self)
        
        storage.remove(key: arrayObjectsKey)
        let deleted = storage.get(key: arrayObjectsKey)
        
        //assert
        XCTAssertEqual(arrayOfObjects, storing)
        XCTAssertNil(deleted)
    }
    
    func testRAMStoringDict() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "RAM")!
        let dictOfObjectsKey = "dictOfObjectsKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let dictOfObjects = ["key": objectValue]

        
        //act
        try? storage.set(key: dictOfObjectsKey, value: dictOfObjects)
        let storing = storage.get(key: dictOfObjectsKey, type: [String: CodableMock].self)
        
        storage.remove(key: dictOfObjectsKey)
        let deleted = storage.get(key: dictOfObjectsKey)
        
        //assert
        XCTAssertEqual(dictOfObjects, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringString() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "Shared")!
        let stringKey = "Key"
        let stringValue = "Value"
        
        //act
        try? storage.set(key: stringKey, value: stringValue)
        let storing = storage.get(key:stringKey)
        
        storage.remove(key: stringKey)
        let deleted = storage.get(key:stringKey)
        
        //assert
        XCTAssertEqual(stringValue, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringObject() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "Shared")!
        let objectKey = "ObjectKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        
        //act
        try? storage.set(key: objectKey, value: objectValue)
        let storing = storage.get(key: objectKey, type: CodableMock.self)
        
        storage.remove(key: objectKey)
        let deleted = storage.get(key: objectKey)
        
        //assert
        XCTAssertEqual(objectValue, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringArrays() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "Shared")!
        let arrayObjectsKey = "arrayObjectsKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let arrayOfObjects = [objectValue, objectValue]
        
        
        //act
        try? storage.set(key: arrayObjectsKey, value: arrayOfObjects)
        let storing = storage.get(key: arrayObjectsKey, type: [CodableMock].self)
        
        storage.remove(key: arrayObjectsKey)
        let deleted = storage.get(key: arrayObjectsKey)
        
        //assert
        XCTAssertEqual(arrayOfObjects, storing)
        XCTAssertNil(deleted)
    }
    
    func testSharedStoringDict() {
        
        //arrange
        let storage = ApplicationAssembler.shared.assembler.resolver.resolve(StorageCore.self, name: "Shared")!
        let dictOfObjectsKey = "dictOfObjectsKey"
        let objectValue = CodableMock(name: "Mock", age: 0, array: ["testing1", "testing2"])
        let dictOfObjects = ["key": objectValue]
        
        
        //act
        try? storage.set(key: dictOfObjectsKey, value: dictOfObjects)
        let storing = storage.get(key: dictOfObjectsKey, type: [String: CodableMock].self)
        
        storage.remove(key: dictOfObjectsKey)
        let deleted = storage.get(key: dictOfObjectsKey)
        
        //assert
        XCTAssertEqual(dictOfObjects, storing)
        XCTAssertNil(deleted)
    }
}
