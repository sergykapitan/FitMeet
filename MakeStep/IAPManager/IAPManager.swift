//
//  IAPManager.swift
//  MakeStep
//
//  Created by Sergey on 02.11.2021.
//

import Foundation
import StoreKit
import Combine

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    private override init() {}
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeProduct: AnyCancellable?
    
    var channelID: String?
    
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
            IAPProducts.consumable.rawValue,
          //  IAPProducts.nonRenewable.rawValue,
          //  IAPProducts.autoMonthSubscription.rawValue,
        ]
        
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    public func purchase(productWith identifier: String,channelId: String) {
        self.channelID = channelId
        guard let product = products.filter({ $0.productIdentifier == identifier }).first else { return }
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    public func restoreCompletedTransactions() {
        paymentQueue.restoreCompletedTransactions()
    }
}


extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      
            for transaction in transactions {
                switch transaction.transactionState {
                case .deferred: break
                case .purchasing: break
                case .failed: failed(transaction: transaction)
                case .purchased: completed(transaction: transaction)
                case .restored: restored(transaction: transaction)
               
                }
            }
        
    }
    private func failed(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Ошибка транзакции: \(transaction.error!.localizedDescription)")
            }
        }
        paymentQueue.finishTransaction(transaction)
    }
    
    private func completed(transaction: SKPaymentTransaction) {
        
        guard let id = channelID,let idProduct =  products.first?.productIdentifier ,let trans = transaction.transactionIdentifier else { return }
        validateProduct(id: id, product: ValidateProduct(appleProductId:idProduct , applePurchaseId: trans ))
        
        
        
        paymentQueue.finishTransaction(transaction)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
    }
    private func validateProduct(id: String,product:ValidateProduct) {
        takeProduct = fitMeetApi.subscribeApp(id: id, product: product)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response != nil {
                    
                }
        })
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products.forEach { print($0) }
    }
}




























