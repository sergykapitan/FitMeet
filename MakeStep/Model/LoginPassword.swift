//
//  LoginPassword.swift
//  FitMeet
//
//  Created by novotorica on 16.04.2021.
//
import Foundation

struct LoginPassword: Codable {
    var email: String?
    var phone: String?
    let password: String
}
struct UserRequest: Codable {
    var fullName: String?
    var username: String?
    var birthDate: String?
    var gender: String?
    var avatarPath: String?    
}
