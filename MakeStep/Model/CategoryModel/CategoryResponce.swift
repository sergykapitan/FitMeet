//
//  CategoryResponce.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation

// MARK: - CategoryResponce
struct CategoryResponce: Codable ,Hashable{
    var data: [Datum]?
    //let meta: Meta?
}

// MARK: - Datum
struct Datum: Codable ,Hashable{
    
    let createdAt: String?
    let id: Int?
    let deleted, name, title, datumDescription: String?
    let previewPath: String?
    let resizedPreview: [String: ResizedPreview]?
    let followersCount: Int
    let rate: Double?
    let isNew, isPopular : Bool
    let isFollow: Bool?
}

enum CreatedAt: String, Codable ,Hashable{
    case the20210413T103846947Z = "2021-04-13T10:38:46.947Z"
    case the20210413T103939379Z = "2021-04-13T10:39:39.379Z"
}

enum Deleted: String, Codable ,Hashable{
    case notDeleted = "NOT_DELETED"
}
// MARK: - ResizedPreview
//struct ResizedPreview: Codable,Hashable {
//    let jpeg, png, webp: String?
//}


