//
//  ResponceLogin.swift
//  FitMeet
//
//  Created by novotorica on 16.04.2021.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responceLogin = try? newJSONDecoder().decode(ResponceLogin.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let responceLogin = try? newJSONDecoder().decode(ResponceLogin.self, from: jsonData)

import Foundation

// MARK: - ResponceLogin
struct ResponceLogin: Codable {
    let user: User?
    let token: Token?
}


 //MARK: - User
struct User: Codable {
    let id: Int?
    let deleted: String?
    let avatarPath: JSONNull?
    let fullName, username, gender, status: String?
    let email, phone: String?
    let phoneVerify: Bool?
    let createdAt: String?
    let birthDate, nameLastUpdateDate, usernameLastUpdateDate: JSONNull?
}
// MARK: - Token
struct Token: Codable {
    let expiresIn: Int?
    let token: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
