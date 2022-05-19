//
//  Validation.swift
//  MakeStep
//
//  Created by Sergey on 04.05.2022.
//
import Foundation

class Validation {
   public func validateName(name: String) ->Bool {
      let nameRegex = "^[A-Za-zА-я]{2,120}$"
      let trimmedString = name.trimmingCharacters(in: .whitespaces)
      let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
      let isValidateName = validateName.evaluate(with: trimmedString)
      return isValidateName
   }
   public func validatePassword(password: String) -> Bool {
      let passRegEx = "^[0-9a-zA-Z!#$%&*@^А-я-]{8,64}$"
      let trimmedString = password.trimmingCharacters(in: .whitespaces)
      let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
      let isvalidatePass = validatePassord.evaluate(with: trimmedString)
      return isvalidatePass
   }
    public func validateUserName(userName: String) -> Bool {
       let passRegEx = "^(?=.*[A-Za-z])[0-9a-zA-Z]{3,64}$"
       let trimmedString = userName.trimmingCharacters(in: .whitespaces)
       let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
       let isvalidatePass = validatePassord.evaluate(with: trimmedString)
       return isvalidatePass
    }
}
