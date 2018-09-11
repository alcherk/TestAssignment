//
//  MotorDiaryTests.swift
//  MotorDiaryTests
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import XCTest
@testable import MotorDiary

struct SomeData: Codable {
    let string: String
    let int: Int
}

class StorageTests: XCTestCase {
    
    private let fileName = "testFileName.json"
    private var storage: Storage!
    
    override func setUp() {
        super.setUp()
        storage = Storage(fileName: fileName)
        storage.clean()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanSave() {
        let data = SomeData(string: "Data", int: 1)
        storage.save(data)
        XCTAssertTrue(storage.exists(), "Data not saved. File doesn't exist")
    }
    
    func testCanLoad() {
        let data = SomeData(string: "Test", int: 42)
        storage.clean()
        XCTAssertFalse(storage.exists(), "There shouldn't be a stored file")
        
        storage.save(data)
        
        let loaded = storage.load(as: SomeData.self)
        if let newData = loaded {
            XCTAssertTrue(data.int == newData.int, "Loaded data should be the same as saved")
        }
        else {
            XCTFail()
        }
    }
    
}
