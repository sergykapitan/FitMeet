//
//  AppleProduct.swift
//  MakeStep
//
//  Created by Sergey on 11.11.2021.
//

import Foundation


// MARK: - AppleProduct
struct AppleProduct: Codable {
    let data: [DataProduct]
}

// MARK: - Datum
struct DataProduct: Codable {
    let createdAt: String
    let id: Int
    let deleted, appleProductId, productType, displayName: String
    let description: String
    let applePrice, price: Int
    let oneTime: Bool
    let periodType: String
    let periodCount: Int

  
}

