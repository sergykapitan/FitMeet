//
//  ExDate.swift
//  MakeStep
//
//  Created by novotorica on 05.08.2021.
//

import Foundation

//    let dateFormatterGet = NSDateFormatter()
//    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//    let dateFormatterPrint = NSDateFormatter()
//    dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//
//    let date: NSDate? = dateFormatterGet.dateFromString("2016-02-29 12:24:26")
//    print(dateFormatterPrint.stringFromDate(date!))

//    Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
//    09/12/2018                        --> MM/dd/yyyy
//    09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
//    Sep 12, 2:11 PM                   --> MMM d, h:mm a
//    September 2018                    --> MMMM yyyy
//    Sep 12, 2018                      --> MMM d, yyyy
//    Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
//    2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
//    12.09.18                          --> dd.MM.yy
//    10:41:02.112                      --> HH:mm:ss.SSS

public extension Date {

       func getFormattedDate(format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: self)
        
    }
}
extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
extension Int {

    func secondsToTime() -> String {

        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)

        let h_string = h < 10 ? "0\(h)" : "\(h)"
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"

        return "\(h_string):\(m_string):\(s_string)"
    }
}

public extension String {

    func getFormattedDate(format: String) -> String {
        
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]

        guard let realDate = isoDateFormatter.date(from: self) else { return "00:00"}
            print("Got it: \(realDate)")
           return  realDate.getFormattedDate(format: format)
        
        
    }
    func getFormattedDateR(format: String) -> Date {

//        let isoDateFormatter = ISO8601DateFormatter()
//        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        isoDateFormatter.formatOptions = [
//            .withFullDate,
//            .withFullTime,
//            .withDashSeparatorInDate,
//            .withFractionalSeconds]
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        guard let date = dateformat.date(from: self) else { return Date()}
        return date

//        guard let realDate = isoDateFormatter.date(from: self) else { return Date()}
//            print("Got it: \(realDate)")
//           return  realDate
        
        
    }
}

let formatter = ISO8601DateFormatter()

class DateTextItem: NSObject {
    var text: String = ""
    var insertDate: NSDate = NSDate()
}

var testArray = [DateTextItem]()

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}
