//
//  StreamResponce.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation
struct StreamResponce: Codable {
    
    let message: [String]?
    let error: String?
    let createdAt: String?
    let id: Int?
    let deleted: String?
    let userID: Int?
    let name, url: String?
    let isActive: Bool?
    let updatedAt: String?
  //  let recordFilePath: NSNull
    let gcoreID, gcoreClientID: Int?
    let token: String?
}
