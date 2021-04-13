//
//  Extensins+String.swift
//  FitMeet
//
//  Created by novotorica on 13.04.2021.
//

import Foundation
extension String {
      func isValidEmail() -> Bool {
          // here, `try!` will always succeed because the pattern is valid
          let regex = try! NSRegularExpression(pattern: "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,3})$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Email validation \(valid)")
          return valid
      }

      // vrify Valid PhoneNumber or Not
      func isValidPhone() -> Bool {

        let regex = try! NSRegularExpression(pattern: "^[0-9]\\d{9}$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Mobile validation \(valid)")
          return valid
      }
  }
