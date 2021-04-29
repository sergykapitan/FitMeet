//
//  ResponcePassword.swift
//  FitMeet
//
//  Created by novotorica on 27.04.2021.
//

import Foundation


// MARK: - ResponcePassword
struct ResponcePassword: Codable {
    let user: Users?
    let token: Tokens?
    //let statusCode: Int?
   // let message, error: String?
}


 //MARK: - User
struct Users: Codable {
    let id: Int?
    let deleted: String?
   // let avatarPath: JSONNull?
    let fullName, username, gender, status: String?
    let email, phone: String?
    let phoneVerify: Bool?
    let createdAt: String?
   // let birthDate, nameLastUpdateDate, usernameLastUpdateDate: JSONNull?
}
// MARK: - Token
struct Tokens: Codable {
    let expiresIn: Int?
    let token: String?
}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}