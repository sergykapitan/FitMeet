//
//  CalendarClass.swift
//  MakeStep
//
//  Created by novotorica on 06.08.2021.
//

import Foundation

class CalendarClass {
    
//    private static func getAllDates(month: Int, year: Int) -> [CalendarDay] {
//        var calendarDays: [CalendarDay] = []
//     
//        let dateComponents = DateComponents(year: year, month: month)
//        let calendar = Calendar.current
//     
//        guard let firstDateOfMonth = calendar.date(from: dateComponents) else { return [] }
//        guard let range = calendar.range(of: .day, in: .month, for: firstDateOfMonth) else { return [] }
//     
//        let numDaysInMonth = range.count
//     
//        for day in 0...numDaysInMonth - 1 {
//            let dateString = firstDateOfMonth.addDays(day).resetTimeTo().toString()
//     
//            let updatedCalendarDays = CalendarDay(value: dateString, available: true)
//            calendarDays.append(updatedCalendarDays)
//        }
//        return calendarDays
//    }
//    
//    private static func getCalendarMonths(_ startAt: String, stopAt: String) -> [CalendarMonth] {
//        var calendarMonths: [CalendarMonth] = []
//     
//        let minStartAt = startAt.toDate()
//        let minStopAt = stopAt.toDate()
//     
//        let minStartMonth = minStartAt?.toString("MM")
//     
//        let minStopMonth = minStopAt?.toString("MM")
//        let minStopYear = minStopAt?.toString("yyyy")
//     
//        if let startMonth = minStartMonth, let endMonth = minStopMonth, let endYear = minStopYear {
//            let intStartMonth = Int(startMonth) ?? 0
//            let intEndMonth = Int(endMonth) ?? 0
//            let intEndYear = Int(endYear) ?? 0
//     
//            if (intStartMonth < intEndMonth) {
//                for month in intStartMonth..<intEndMonth + 1 {
//                    let updateCalendarMonth = CalendarMonth(month: month, year: intEndYear, days: getAllDates(month: month, year: intEndYear))
//                    calendarMonths.append(updateCalendarMonth)
//                }
//            }
//        }
//        return calendarMonths
//    }
//    
//    public static func generateData() -> CalendarMonths {
//        let calendarMonths = CalendarMonths(
//            calendarMonths: getCalendarMonths("2020-01-01T07:00:00.000+08:00", stopAt: "2020-12-31T10:00:00.000+08:00"))
//     
//        return calendarMonths
//    }
//    
//    static public func configureData() -> CalendarMonths {
//        dateModel = generateData()
//     
//        var modifiedSurchargeDates = [CalendarDay]()
//        var modifiedDateTime: [CalendarMonth] = []
//     
//        dateModel?.calendarMonths?.forEach({ (calendarDay) in
//            guard let firstDateOfTheMonth = calendarDay.days?.first?.value?.toDate() else { return }
//     
//            let noOfEmptyDaysOfMonth = Days.init(rawValue: firstDateOfTheMonth.getDay())?.getEmptyDays()
//            if let count = noOfEmptyDaysOfMonth {
//                for _ in 0..<count {
//                    modifiedSurchargeDates.append(CalendarDay.empty())
//                }
//            }
//            modifiedSurchargeDates += calendarDay.days ?? []
//     
//            let date = CalendarMonth(month: calendarDay.month, year: calendarDay.year, days: modifiedSurchargeDates)
//            modifiedDateTime.append(date)
//     
//            modifiedSurchargeDates = []
//        })
//     
//        let modifiedModel = CalendarMonths(calendarMonths: modifiedDateTime)
//        return modifiedModel
//    }
}
