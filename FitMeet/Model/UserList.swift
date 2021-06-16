//
//  UserList.swift
//  FitMeet
//
//  Created by novotorica on 15.06.2021.
//

import Foundation
import Foundation

// MARK: - Welcome5
struct UserList:Codable {
    let data: [Users]
    let meta: Meta
}


// MARK: - Meta
struct Meta: Codable {
    let page, take, itemCount, pageCount: Int
}
