//
//  CategoryResponce.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation

// MARK: - CategoryResponce
struct CategoryResponce: Codable ,Hashable{
    let data: [Datum]?
    //let meta: Meta?
}

// MARK: - Datum
struct Datum: Codable ,Hashable{
    let createdAt: CreatedAt?
    let id: Int?
    let deleted: Deleted?
    let title: String?
}

enum CreatedAt: String, Codable ,Hashable{
    case the20210413T103846947Z = "2021-04-13T10:38:46.947Z"
    case the20210413T103939379Z = "2021-04-13T10:39:39.379Z"
}

enum Deleted: String, Codable ,Hashable{
    case notDeleted = "NOT_DELETED"
}

// MARK: - Meta
//struct Meta: Codable,Hashable {
//    let page, take, itemCount, pageCount: Int?
//}
