//
//  EntryViewModel.swift
//  MotorDiary
//
//  Created by lex on 11/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import Foundation

enum EntryStatus {
    case unknown
    case filled
    case future
}

protocol DiaryEntryModelDelegate: class {
    func valueChanged(_ entry: DiaryEntry)
}

class EntryViewModel {
    private let entry: DiaryEntry
    private weak var delegate: DiaryEntryModelDelegate?
    
    init(entry: DiaryEntry, delegate: DiaryEntryModelDelegate?) {
        self.entry = entry
        self.delegate = delegate
    }
    
    var status: EntryStatus {
        if entry.time > Date() {
            return .future
        }
        
        if entry.type != .unknown {
            return .filled
        }
        
        return .unknown
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: entry.time)
    }
    
    var selectionIndex: Int? {
        guard entry.type != .unknown else { return nil }
        return entry.type.rawValue
    }
    
    func updateType(index: Int) {
        if let type = ActivityType(rawValue: index) {
            let newEntry = DiaryEntry(time: entry.time, type: type)
            delegate?.valueChanged(newEntry)
        }
    }
}
