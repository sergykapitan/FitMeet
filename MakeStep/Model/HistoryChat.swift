//
//  HistoryChat.swift
//  MakeStep
//
//  Created by novotorica on 31.08.2021.
//

import Foundation


// MARK: - HistoryChat
struct HistoryChat: Codable {
    let data: [Datums]?
}

// MARK: - Datum
struct Datums: Codable {
    let id: String?
    let payload: Payload?
    let user: Usersa?
    let timestamp, socketEvent: String?
}

// MARK: - Payload
struct Payload: Codable {
    let messageType: String?
 
    let message: Messages?
  

}

// MARK: - Message
struct Messages: Codable {
    let text: String?
}

// MARK: - User
struct Usersa: Codable {
    let userID, sessionID: Int?
    let username, fullName, room, clientID: String?
    let role: String?
    let isSponsor, isSubscriber: Bool?


}

// MARK: - Meta
//struct Metas: Codable {
//    let take, itemCount: Int?
//}

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

 //   }
//}
