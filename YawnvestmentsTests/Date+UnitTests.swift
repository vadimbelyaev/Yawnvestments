//
//  Date+UnitTests.swift
//  YawnvestmentsTests
//
//  Created by Vadim Personal on 6/28/20.
//  Copyright © 2020 Vadim Belyaev. All rights reserved.
//

import Foundation

internal extension Date {
    static func make(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let components = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(secondsFromGMT: 0), year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0)
        return components.date!
    }
}
