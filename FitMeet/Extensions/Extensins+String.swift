//
//  Extensins+String.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
 
extension String {
   func isValidEmailN() -> Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   func isValidPhoneM() -> Bool {
      let regularExpressionForPhone = "^[0-9+]{0,1}+[0-9]{9,11}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
    func validate(value: String) -> Bool {
        if value == "0"||value == "1"||value == "2"||value == "3"||value == "4"||value == "5"||value == "6"||value == "7"||value == "8"||value == "9" {
            return true
        } else {
            return false
            
        }
    }
}
