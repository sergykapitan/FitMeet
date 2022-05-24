//
//  BroadcastResponce.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation

struct BroadcastList: Codable,Equatable {
    var data: [BroadcastResponce]?
    let meta: MetaBroadcast?
}

struct BroadcastResponce:Codable,Equatable,Hashable {
    var message: String?
    var error: String?
    var createdAt: String?
    var id: Int?
    var deleted: String?
    var userId: Int?
    var name, type, access: String?
    let status: BroadcastStatus?
    var hasChat, isPlanned: Bool?
    var scheduledStartDate, startDate, endDate: String?
   // let onlyForSubscribers, onlyForSponsors: Bool?
    let viewersCount: Int?
    var updatedAt: String?
    var gcoreId, gcoreClientId: Int?
    var gcoreStatus: String?
    var url, iframeURL: String?
    var previewPath: String?
    var categories: [Category]?
    var streams: [Stream]?
    var iframeUrl: String?
    var isPopular: Bool?
    var description: String?
    var followersCount: Int?
    var channelIds: [Int]?
    var isFollow: Bool?
    var isSubscriber: Bool?
    var resizedPreview: [String: ResizedPreview]?
    var privateUrlKey: String?

}
// MARK: - ResizedPreview
struct ResizedPreview: Codable,Hashable,Equatable {
    var jpeg, png, webp: String?
}

// MARK: - Category
struct Category: Codable,Equatable,Hashable{
    var createdAt: String?
    var id: Int?
    var title, name, categoryDescription: String?
    var description: String?
    var followersCount: Int
    var previewPath: String?
    var rate: Int?
    var isNew, isPopular: Bool?
    var isFollow: Bool?
   
}
struct Stream: Codable,Equatable,Hashable {
    var createdAt: String?
    var id: Int?
    var userId: Int?
    var name: String?
    var isActive: Bool?
    var updatedAt: String?
    var gcoreId, gcoreClientId: Int?
    var hlsPlaylistUrl: String?
    var hlsPlaylistUrl360: String?
    var hlsPlaylistUrl480: String?
    var hlsPlaylistUrl720: String?
    var hlsPlaylistUrl1080: String?
    var vodUrl360: String?
    var vodUrl480: String?
    var vodUrl720: String?
    var vodUrl1080: String?
    var dashURL: String?
    var vodUrl: String?
    var vodLength: Int?
}
struct MetaBroadcast: Codable,Equatable,Hashable {
    var page: Int?
    var take: Int?
    var itemCount: Int?
    var pageCount: Int?
}
enum BroadcastStatus :String, Codable,Equatable,Hashable{
    case online = "ONLINE"
    case offline = "OFFLINE"
    case planned = "PLANNED"
    case banned = "BANNED"
    case finished = "FINISHED"
    case wait_for_approve = "WAIT_FOR_APPROVE"
    var description : String {
        switch self {
        case .online: return "ONLINE"
        case .offline: return "OFFLINE"
        case .planned: return "PLANNED"
        case .banned: return "BANNED"
        case .finished: return "FINISHED"
        case .wait_for_approve: return "WAIT_FOR_APPROVE"
        }
    }
}
