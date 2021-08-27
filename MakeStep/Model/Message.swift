//
//  Message.swift
//  MakeStep
//
//  Created by novotorica on 07.08.2021.
//

import Foundation

struct Message: Codable {
    let id: String?
    let payload: PayLoad?
    let socketEvent: String?
    let timestamp:String?
    let user: Usr?
    let messageSender: MessageSender
    
 //  init(message: String, messageSender: MessageSender, username: String) {      
 //    self.messageSender = messageSender
 //       self.user?.fullName = username
 //      self.payload?.message?.text = message.withoutWhitespace()
 //   }
}
   
struct PayLoad: Codable {
    
    let  message: MessageText?
    let  messageType: String?
    let  targetMessageId: Bool?
    let  targetUserId: Bool?

    }
    struct MessageText: Codable  {
        let text: String?
    }

struct Usr : Codable {
        let clientId: String?
        let fullName: String?
        let isSponsor: Bool?
        let isSubscriber: Bool?
        let role: String?
        let room: String?
        let sessionId: Int?
        let userId: Int?
        let username: String?
    }
