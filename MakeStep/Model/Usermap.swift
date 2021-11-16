//
//  Usermap.swift
//  MakeStep
//
//  Created by novotorica on 23.08.2021.
//

import Foundation
// MARK: - UploadImage

struct UploadMapUser: Codable {
    let data: [Int: User]
}
struct UploadMapCategores: Codable {
    let data: [Int: Datum]
}

