//
//  Responce.swift
//  MakeStep
//
//  Created by novotorica on 20.07.2021.
//

import Foundation

struct Responce: Codable {
    let error: String
    let limit,offset,nuberOfPage,numberTotalResult : Int
    let version: String
}
