//
//  Usermap.swift
//  MakeStep
//
//  Created by novotorica on 23.08.2021.
//

import Foundation
// MARK: - UploadImage
struct UploadImages: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let additionalProp: AdditionalProp?
}

// MARK: - AdditionalProp
struct AdditionalProp: Codable {
    let createdAt: String?
    let id: Int?
    let deleted, fullName, username: String?
    let gender: String?
    let status: String?
    let email, phone, avatarPath: String?
    let phoneVerify: Bool?
    let birthDate: String?
    let channelFollowCount, channelSubscribeCount, broadcastFollowCount, broadcastSponsorCount: Int?
    let broadcastCategoryFollowCount: Int?
    let nameLastUpdateDate, usernameLastUpdateDate, banReason: String?
    let banAdminID: Int?
    let birthDateLastUpdateDate, changeStatusDate, lastActivityDate: String?

//    enum CodingKeys: String, CodingKey {
//        case createdAt, id, deleted, fullName, username, gender, status, email, phone, avatarPath, phoneVerify, birthDate, channelFollowCount, channelSubscribeCount, broadcastFollowCount, broadcastSponsorCount, broadcastCategoryFollowCount, nameLastUpdateDate, usernameLastUpdateDate, banReason
//        case banAdminID
//        case birthDateLastUpdateDate, changeStatusDate, lastActivityDate
//    }
}

// MARK: - Gender
struct Gender: Codable {
    let male, female, undefined: String?

    enum CodingKeys: String, CodingKey {
        case male
        case female
        case undefined
    }
}

// MARK: - Status
struct Status: Codable {
    let banned, active: String?

    enum CodingKeys: String, CodingKey {
        case banned
        case active
    }
}
