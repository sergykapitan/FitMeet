//
//  IAPManager.swift
//  MakeStep
//
//  Created by Sergey on 02.11.2021.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    private override init() {}
    
    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()
    
    public func setupPurchases(callback: @escaping(Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callback(true)
            return
        }
        callback(false)
    }
    
    public func getProducts() {
        let identifiers: Set = [
            IAPProducts.nonRenewable.rawValue,
            IAPProducts.autoMonthSubscription.rawValue,
        ]
        
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    public func purchase(productWith identifier: String) {
        guard let product = products.filter({ $0.productIdentifier == identifier }).first else { return }
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    
}


extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction in transactions {
                switch transaction.transactionState {
                case .deferred: break
                case .purchasing: break
                case .failed: print("failed")
                case .purchased: print("purchased")
                case .restored: print("restored")
                @unknown default:
                    print("fatal eror")
                }
            }
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products.forEach { print($0) }
    }
}




























