//
//  BroadcastRequest.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation

//struct BroadcastRequest: Codable {
//    
//    let channelID: Int?
//    let name: String?
//    let type: String?
//    let access: String?
//    let hasChat: Bool?
//    let isPlanned: Bool?
//    let onlyForSponsors: Bool?
//    let onlyForSubscribers: Bool?
//    let categoryIDS: [Int]
//    let scheduledStartDate: String
//}

//   let categoryResponce = try? newJSONDecoder().decode(CategoryResponce.self, from: jsonData)


import Foundation
import Alamofire

// MARK: - CategoryResponce
struct BroadcastRequest: Codable {
    let channelID: Int?
    let name, type, access: String?
    let hasChat, isPlanned, onlyForSponsors, onlyForSubscribers: Bool?
    
    let categoryIDS: [Int]?
    let scheduledStartDate: String?
    let description: String?
    let previewPath: String?

    enum CodingKeys: String, CodingKey {
        case channelID = "channelId"
        case name, type, access, hasChat, isPlanned, onlyForSponsors, onlyForSubscribers
        case categoryIDS = "categoryIds"
        case scheduledStartDate
        case description
        case previewPath
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

//extension DataRequest {
//    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
//        return DataResponseSerializer { _, response, data, error in
//            guard error == nil else { return .failure(error!) }
//
//            guard let data = data else {
//                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//            }
//
//            return Result { try newJSONDecoder().decode(T.self, from: data) }
//        }
//    }
//
//    @discardableResult
//    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//    }
//
//    @discardableResult
//    func responseCategoryResponce(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<CategoryResponce>) -> Void) -> Self {
//        return responseDecodable(queue: queue, completionHandler: completionHandler)
//    }
//}
