//
//  Calendar.swift
//  MakeStep
//
//  Created by novotorica on 06.08.2021.
//

import Foundation

public struct CalendarDay {
    let value: String?
    let available: Bool?
 
    public init(value: String? = nil, available: Bool = true) {
        self.value = value
        self.available = available
    }
}

public struct CalendarMonth {
 
    let month: Int
    let year: Int
    let days: [CalendarDay]?
 
    public init(month: Int, year: Int, days: [CalendarDay]) {
        self.month = month
        self.year = year
        self.days = days
    }
}
public struct CalendarMonths {
    var calendarMonths: [CalendarMonth]?
 
    public init(calendarMonths: [CalendarMonth]?) {
        self.calendarMonths = calendarMonths
    }
}
public enum Days: String {
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun
}
 
extension Days {
    func getEmptyDays() -> Int {
        switch self {
 
        case .Mon:
            return 0
        case .Tue:
            return 1
        case .Wed:
            return 2
        case .Thu:
            return 3
        case .Fri:
            return 4
        case .Sat:
            return 5
        case .Sun:
            return 6
        }
    }
}
