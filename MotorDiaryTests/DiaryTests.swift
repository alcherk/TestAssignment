//
//  DiaryTests.swift
//  MotorDiaryTests
//
//  Created by lex on 11/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import XCTest
@testable import MotorDiary

class MockStorage: StorageProtocol {
    required init(fileName: String) { }
    
    private var value: [DiaryEntry]!
    
    func save<T>(_ object: T) where T : Encodable {
        value = object as! [DiaryEntry]
    }
    
    func load<T>(as type: T.Type) -> T? where T : Decodable {
        return value as? T
    }
    
    func exists() -> Bool { return value != nil }
    
    func clean() { }
    
    func savedData() -> [DiaryEntry] {
        return value
    }
}

class DiaryTests: XCTestCase {
    
    private var mockStorage: MockStorage!
    
    override func setUp() {
        super.setUp()
        
        mockStorage = MockStorage(fileName: "mock_file")
        mockStorage.clean()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDiaryHas48Entries() {
        let diary = Diary(storage: mockStorage)
        XCTAssertTrue(diary.count == 48, "There should be entries for each 30 min")
    }
    
    func testDiarySavesDataToStorage() {
        let diary = Diary(storage: mockStorage)
        diary.save()
        
        let savedData = mockStorage.savedData()
        XCTAssertTrue(savedData.count == 48, "It should save all 48 entries")
        XCTAssertTrue(diary[0].time == savedData[0].time, "First objects for original data and stored data should be the same")
    }
    
    func testDiaryCanLoadStoredData() {
        let testIndex = 2
        let diary = Diary(storage: mockStorage)
        let thirdEntry = diary[testIndex]
        let entry = DiaryEntry(time: thirdEntry.time, type: .d_on)
        diary.update(entry: entry)
        diary.save()
        
        let another = Diary(storage: mockStorage)
        
        XCTAssertTrue(another[testIndex].type == .d_on, "Loaded data entry should have same type as saved one")
    }
}
