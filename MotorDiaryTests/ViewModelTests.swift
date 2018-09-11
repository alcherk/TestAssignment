//
//  ViewModelTests.swift
//  MotorDiaryTests
//
//  Created by lex on 11/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import XCTest
@testable import MotorDiary

class MockDelegate: DiaryEntryModelDelegate {
    private(set) var entry: DiaryEntry?
    
    func valueChanged(_ entry: DiaryEntry) {
        self.entry = entry
    }
}

class ViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func createConcreteDateTime(future: Bool) -> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now) + (future ? 1 : -1)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.minute = 30
        nowComponents.hour = 18
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    func testSelectionIndexIsNilForUnknown() {
        let date = createConcreteDateTime(future: false)
        let entry = DiaryEntry(time: date, type: .unknown)
        let viewModel = EntryViewModel(entry: entry, delegate: nil)
        
        XCTAssertNil(viewModel.selectionIndex, "Index should be nil for .unknown status")
    }
    
    func testFutureDateShouldReturnFutureStatus() {
        let date = createConcreteDateTime(future: true)
        let entry = DiaryEntry(time: date, type: .unknown)
        let viewModel = EntryViewModel(entry: entry, delegate: nil)
        
        XCTAssertTrue(viewModel.status == .future, "For future date should be .future status")
    }
    
    func testShouldReturnFilledStatusForSelectedActivity() {
        let date = createConcreteDateTime(future: false)
        let entry = DiaryEntry(time: date, type: .d_on)
        let viewModel = EntryViewModel(entry: entry, delegate: nil)
        
        XCTAssertTrue(viewModel.status == .filled, "It should return .filled for selected activity")
    }
    
    func testShouldNotifyOnValueChanged() {
        let delegate = MockDelegate()
        let date = createConcreteDateTime(future: false)
        let entry = DiaryEntry(time: date, type: .unknown)
        let viewModel = EntryViewModel(entry: entry, delegate: delegate)
        
        viewModel.updateType(index: ActivityType.d_on.rawValue)
        let passedToDelegate = delegate.entry
        
        XCTAssertNotNil(passedToDelegate, "There should be a value passed to delegate")
        XCTAssertTrue(passedToDelegate?.type == .d_on, "It should have a new value for activity")
    }
}
