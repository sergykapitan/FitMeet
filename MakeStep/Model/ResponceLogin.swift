//
//  ResponceLogin.swift
//  FitMeet
//
//  Created by novotorica on 16.04.2021.
//


import Foundation

// MARK: - ResponceLogin
struct ResponceLogin: Codable,Identifiable {
    var id: UUID?
    let user: User?
    let token: Token?
    let statusCode: Int?
    let message: String?
    let error: String?
}


 //MARK: - User
struct User: Codable,Identifiable {
    let statusCode: Int?
    let message: String?
    let error: String?
    let id: Int?
    let deleted: String?
    let avatarPath: String?
    let fullName, username, gender, status: String?
    let email, phone: String?
    let phoneVerify: Bool?
    let createdAt: String?
    let birthDate: String?
    let nameLastUpdateDate, usernameLastUpdateDate: String?
    let channelFollowCount: Int?
    let channelSubscribeCount: Int?
}
// MARK: - Token
struct Token: Codable,Identifiable {
    var id: UUID?
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
