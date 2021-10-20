//
//  BroadcastResponce.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation

struct BroadcastList: Codable {
    let data: [BroadcastResponce]?
}

struct BroadcastResponce:Codable {
    let message: String?
    var error: String?
    let createdAt: String?
    let id: Int?
    let deleted: String?
    let userId: Int?
    let name, type, access: String?
    let hasChat, isPlanned: Bool?
    let scheduledStartDate, startDate, endDate, status: String?
   // let onlyForSubscribers, onlyForSponsors,followersCount: Bool?
    let updatedAt: String?
    let gcoreId, gcoreClientId: Int?
    let gcoreStatus: String?
    let url, iframeURL: String?
    let previewPath: String?
    let categories: [Category]?
    let streams: [Stream]?
    let iframeUrl: String?
    let isPopular: Bool?
    let description: String?
    let followersCount: Int?
    let channelIds: [Int]?
    let isFollow: Bool?
    
  
}

// MARK: - Category
struct Category: Codable{
    let createdAt: String?
    let id: Int?
    let title, name, categoryDescription: String?
    let description: String?
    let followersCount: Int
    let previewPath: String?
    let rate: Int?
    let isNew, isPopular: Bool?
    let isFollow: Bool?
   
}
struct Stream: Codable {
    let createdAt: String?
    let id: Int?
    let userId: Int?
    let name: String?
    let isActive: Bool?
    let updatedAt: String?
    let gcoreId, gcoreClientId: Int?
    let hlsPlaylistUrl: String?
    let dashURL: String?
    let vodUrl: String?
}
