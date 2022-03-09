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
    let userId, sessionId: Int?
    let username, fullName, room, clientId: String?
    let role: String?
    let isSponsor, isSubscriber: Bool?


}

