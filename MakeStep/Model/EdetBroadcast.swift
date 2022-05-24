//
//  EdetBroadcast.swift
//  MakeStep
//
//  Created by novotorica on 30.09.2021.
//

import Foundation

// MARK: - EditBroadcast
struct EditBroadcast: Codable {
    let name, access: String?
    let hasChat: Bool?
  //  let scheduledStartDate: String?
    let onlyForSponsors, onlyForSubscribers: Bool?
    let addCategoryIds, removeCategoryIds: [Int]?
    let previewPath: String?
    let rate: Int?
    let description: String?
    let price: Int?
    
}
