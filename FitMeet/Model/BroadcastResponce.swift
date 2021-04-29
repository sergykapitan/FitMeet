//
//  BroadcastResponce.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation

struct BroadcastResponce:Codable {
    let message: [String]?
    var error: String?
    let createdAt: String?
    let id: Int?
    let deleted: String?
    let userID: Int?
    let name, type, access: String?
    let hasChat, isPlanned: Bool?
    let scheduledStartDate, startDate, endDate, status: String?
   // let onlyForSubscribers, onlyForSponsors,followersCount: Bool?
    let updatedAt: String?
    let gcoreID, gcoreClientID: Int?
    let gcoreStatus: String?
    let url, iframeURL: String?
}//sponsorsCount,
