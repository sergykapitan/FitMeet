//
//  EdetBroadcast.swift
//  MakeStep
//
//  Created by novotorica on 30.09.2021.
//

import Foundation

// MARK: - EditBroadcast
struct EditBroadcast: Codable {
    let name, type, access: String?
    let hasChat: Bool?
    let scheduledStartDate: String?
    let onlyForSponsors, onlyForSubscribers: Bool?
    let addCategoryIDS, removeCategoryIDS: [Int]?
    let previewPath: String?
    let rate: Int?
    let description: String?
    let price: Int?
    

//    enum CodingKeys: String, CodingKey {
//        case name, type, access, hasChat, scheduledStartDate, onlyForSponsors, onlyForSubscribers
//        case addCategoryIDS
//        case removeCategoryIDS
//        case previewPath, rate
//        case editBroadcastDescription
//        case price
//        case description
//    
//    }
}
