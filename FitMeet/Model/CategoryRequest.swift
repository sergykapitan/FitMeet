//
//  CategoryRequest.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation
struct CategoryRequest: Codable {
    
    let order: String
    let page: Int
    let take: Int
}
