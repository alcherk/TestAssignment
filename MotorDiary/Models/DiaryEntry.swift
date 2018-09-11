//
//  DiaryEntry.swift
//  MotorDiary
//
//  Created by lex on 10/09/2018.
//  Copyright © 2018 alcherk. All rights reserved.
//

import Foundation

enum ActivityType: Int, Codable {
    case asleep = 0
    case off
    case on
    case d_on
    case unknown
}

struct DiaryEntry: Codable {
    let time: Date
    let type: ActivityType
}
