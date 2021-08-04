//
//  UploadImage.swift
//  MakeStep
//
//  Created by novotorica on 03.08.2021.
//

import Foundation


// MARK: - UploadImage
struct UploadImage: Codable {
    let data: [ReqImage]?
    let meta: MetaImage?
    var message: [String]?
    
}

// MARK: - Datum
struct ReqImage: Codable {
    let mimetype: Int?
    let filename: String?
    let url: String?
}

// MARK: - Meta
struct MetaImage: Codable {
    let itemCount: Int?
}
