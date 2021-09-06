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
    let message: String?
    let error: String?
    let createdAt: String?
    let id: Int?
    let deleted: String?
    let userId: Int?
    let name, title, welcome5Description: String?
    let backgroundUrl, facebookLink, instagramLink, twitterLink: String?
    let status: String?
   // let banReason: Bool?
    let subscribersCount, followersCount: Int?
    let updatedAt: String?
    let description: String?
    let activeBroadcast: ActivBroadCast?
}
struct ActivBroadCast: Codable,Hashable,Identifiable {
    let createdAt: String?
    let id: Int?
    let deleted: String?
    let userId: Int?
    let name: String?
    let url, iframeUrl: String?
    let type, access: String?
    let hasChat, isPlanned: Bool?
    let scheduledStartDate, startDate, status, updatedAt: String?
    let gcoreId, gcoreClientId: Int?
    let gcoreStatus, endDate: String?
    let onlyForSubscribers, onlyForSponsors: Bool?
    let sponsorsCount, followersCount: Int?
    let banReason: String?
    let banAdminId: Int?
    let description: String?
    let previewPath: String?
 
}
