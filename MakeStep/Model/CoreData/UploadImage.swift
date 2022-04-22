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

// MARK: - ReqImage
struct ReqImage: Codable {
    let mimetype: Int?
    let filename: String?
    let url: String?
}

// MARK: - Meta
struct MetaImage: Codable {
    let itemCount: Int?
}

struct ResponseVOD: Codable {
    
    let createdAt, deleted: String?
    let deletedAt: String?
    let bunnyId: String?
    let mimetypeId: Int?
    let adminId: Int?
    let categoryIds: [Int]?
    let published: Bool?
    let byteSize: Int?
    let bunnyStatus: String?
    let streamId, broadcastId, channelId: Int?
    let previewPath, responseVODDescription, title: String?
    let antmediaVodId, antmediaStreamId: Int?
    let vodUrl: String?
    let name: String?
    let userId: Int?
    let signedVodUrl: String?
    let message: String?
    let messages: [String]?
}
