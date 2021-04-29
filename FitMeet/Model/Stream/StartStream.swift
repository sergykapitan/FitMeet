//
//  StartStream.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//
import Alamofire
import Foundation

struct StartStream: Codable {
    let name: String
    let userId, broadcastId: Int

    enum CodingKeys: String, CodingKey {
        case name
        case userId
        case broadcastId
    }
}
