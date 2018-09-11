//
//  Diary.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import Foundation

class Diary {
    fileprivate var activities = [DiaryEntry]()
    private let storage: StorageProtocol
    
    var count: Int {
        return activities.count
    }
    
    init(storage: StorageProtocol) {
        self.storage = storage
        if storage.exists(), let stored = storage.load(as: [DiaryEntry].self) {
            activities = stored
        }
        else {
            generateArray()
        }
    }
    
    func update(entry: DiaryEntry) {
        if let index = activities.index(where: { $0.time == entry.time }) {
            activities[index] = entry
        }
    }
    
    func save() {
        storage.save(activities)
    }
    
    subscript (_ index: Int) -> DiaryEntry {
        return activities[index]
    }
}

extension Diary {
    fileprivate func getStartDate() -> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        let beginningOfHour = (nowComponents.minute ?? 0) < 30
        nowComponents.minute = beginningOfHour ? 30 : 0
        nowComponents.hour = Calendar.current.component(.hour, from: now) + (beginningOfHour ? 0 : 1)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    fileprivate func generateArray() {
        let startDate = getStartDate()
        var dateComponent = DateComponents()
        dateComponent.minute = 30
        var currentDate = startDate
        
        for _ in 0..<48 {
            let entry = DiaryEntry(time: currentDate, type: .unknown)
            activities.append(entry)
            currentDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? currentDate
        }
    }
}
