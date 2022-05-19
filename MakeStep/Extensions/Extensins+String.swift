//
//  Extensins+String.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
import UIKit
 
extension String {
   func isValidEmail() -> Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
    //"^[0-9+]{0,1}+[0-9]{11,13}$"
   func isValidPhone() -> Bool {
      let regularExpressionForPhone = "^[+]{0,1}+[0,1,2,3,4,5,6,7]{0,1}+[0-9]{10,12}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
   func isValidCode() -> Bool {
       let regularExpressionForPhone = "^[0-9]{0,10}$"
       let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
       return testPhone.evaluate(with: self)
    }
    public func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
   func format(phoneNumber:String,shouldRemoveLastDigt: Bool) -> String {
        let maximumNumber = 64
        let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
        guard !(shouldRemoveLastDigt && phoneNumber.count <= 2) else { return ""}
        
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number  = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maximumNumber {
            let maxIndex = number.index(number.startIndex, offsetBy: maximumNumber)
            number = String(number[number.startIndex..<maxIndex])
        }
        if shouldRemoveLastDigt {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        let maxIndex = number.index(number.startIndex,offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
    
        if number.count < 3{
              print("*****")
              let pattern = "(\\d)(\\d+)"
              number = number.replacingOccurrences(of: pattern, with: "+$1$2", options: .regularExpression, range: regRange)
          }
        if number.count < 6 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "+$1$2$3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "+$1$2$3$4$5", options: .regularExpression, range: regRange)
        }
       return number
    }
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    
}
extension String {
  func withoutWhitespace() -> String {
    return self.replacingOccurrences(of: "\n", with: "")
      .replacingOccurrences(of: "\r", with: "")
      .replacingOccurrences(of: "\0", with: "")
  }
        var stringWidth: CGFloat {
            let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
            let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            return boundingBox.width
        }

        var stringHeight: CGFloat {
            let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
            let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            return boundingBox.height
        }
}

extension TimeInterval {
    func convertSecondString() -> String {
        let component =  Date.dateComponentFrom(second: self)
        if let hour = component.hour ,
            let min = component.minute ,
            let sec = component.second {
            
            let fix =  hour > 0 ? NSString(format: "%02d:", hour) : ""
            let a = NSString(format: "%@%02d:%02d", fix,min,sec) as String
            return a
        } else {
            return "-:-"
        }
    }
}
extension Date {
    static func dateComponentFrom(second: Double) -> DateComponents {
        let interval = TimeInterval(second)
        let date1 = Date()
        let date2 = Date(timeInterval: interval, since: date1)
        let c = NSCalendar.current
        
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }
}
