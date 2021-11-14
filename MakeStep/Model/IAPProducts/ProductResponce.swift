//
//  ProductResponce.swift
//  MakeStep
//
//  Created by Sergey on 12.11.2021.
//

import Foundation


struct ProducctResponce: Codable {
    let message: String?
    let verified: Bool?
    let service: String?
    let status: Int?
    let error: String?
}
