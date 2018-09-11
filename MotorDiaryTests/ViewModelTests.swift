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
    
    private func createViewModel(future: Bool, type: ActivityType, delegate: DiaryEntryModelDelegate?) -> EntryViewModel {
        let date = createConcreteDateTime(future: future)
        let entry = DiaryEntry(time: date, type: type)
        return EntryViewModel(entry: entry, delegate: delegate)
    }
    
    func testSelectionIndexIsNilForUnknown() {
        let viewModel = createViewModel(future: false, type: .unknown, delegate: nil)
        
        XCTAssertNil(viewModel.selectionIndex, "Index should be nil for .unknown status")
    }
    
    func testShouldReturnTimeInCorrectFormat() {
        let viewModel = createViewModel(future: false, type: .unknown, delegate: nil)
        
        XCTAssertTrue(viewModel.time == "18:30", "Time format is not match")
    }
    
    func testFutureDateShouldReturnFutureStatus() {
        let viewModel = createViewModel(future: true, type: .unknown, delegate: nil)
        
        XCTAssertTrue(viewModel.status == .future, "For future date should be .future status")
    }
    
    func testShouldReturnFilledStatusForSelectedActivity() {
        let viewModel = createViewModel(future: false, type: .d_on, delegate: nil)
        
        XCTAssertTrue(viewModel.status == .filled, "It should return .filled for selected activity")
    }
    
    func testShouldNotifyOnValueChanged() {
        let delegate = MockDelegate()
        let viewModel = createViewModel(future: false, type: .unknown, delegate: delegate)
        
        viewModel.updateType(index: ActivityType.d_on.rawValue)
        let passedToDelegate = delegate.entry
        
        XCTAssertNotNil(passedToDelegate, "There should be a value passed to delegate")
        XCTAssertTrue(passedToDelegate?.type == .d_on, "It should have a new value for activity")
    }
}
