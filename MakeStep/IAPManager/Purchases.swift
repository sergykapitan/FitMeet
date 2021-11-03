//
//  Purchases.swift
//  MakeStep
//
//  Created by Sergey on 03.11.2021.
//

import Foundation
import StoreKit

class Purchases: NSObject {
    static let `default` = Purchases()

    private let productIdentifiers = Set<String>(
        arrayLiteral: "com.makestep.month.auto"
    )

    private var productRequest: SKProductsRequest?

    func initialize() {
        requestProducts()
    }

    private func requestProducts() {
        productRequest?.cancel()

               let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
               productRequest.delegate = self
               productRequest.start()

               self.productRequest = productRequest
    }
}
extension Purchases: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard !response.products.isEmpty else {
            print("Found 0 products")
            return
        }

        for product in response.products {
            print("Found product: \(product.productIdentifier)")
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load products with error:\n \(error)")
    }
}
