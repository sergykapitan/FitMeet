//
//  ChannelResponce.swift
//  FitMeet
//
//  Created by novotorica on 23.04.2021.
//

import Foundation


// MARK: - Welcome8
struct ChannelResponce: Codable,Hashable,Identifiable{
    let statusCode: Int?
    let message: [String]?
    let error: String?
    let createdAt: String?
    let id: Int?
    let deleted: String?
    let userID: Int?
    let name, title, welcome5Description: String?
    let backgroundURL, facebookLink, instagramLink, twitterLink: String?
    let status: String?
    let banReason: Bool?
    let subscribersCount, followersCount: Int?
    let updatedAt: String?
   // let lastBroadcastDate: NSNull
}
