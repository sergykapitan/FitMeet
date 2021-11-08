//
//  SubscribeVC.swift
//  MakeStep
//
//  Created by novotorica on 20.08.2021.
//

import Foundation
import UIKit

class SubscribeVC: UIViewController {
    
    let subscribeView = SubscribeVCCode()
    let iapManager = IAPManager.shared
    
    override func loadView() {
        view = subscribeView
        self.view.backgroundColor = UIColor.white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
      
    }
    private func actionButton() {
        subscribeView.buttonProduct.addTarget(self, action: #selector(selectProduct), for: .touchUpInside)
        subscribeView.buttonPay.addTarget(self, action: #selector(actionPay), for: .touchUpInside)
    }
    
    @objc private func selectProduct() {
        subscribeView.buttonProduct.isSelected.toggle()
        if subscribeView.buttonProduct.isSelected {
            
        
        subscribeView.buttonProduct.layer.borderWidth = 1
        subscribeView.buttonProduct.layer.masksToBounds = false
        subscribeView.buttonProduct.layer.borderColor = UIColor(hexString: "#3B58A4").cgColor
        subscribeView.buttonProduct.clipsToBounds = true
        subscribeView.buttonProduct.layer.cornerRadius = 30
        
        guard let price = subscribeView.labelProductPrice.text else {return}
        
        subscribeView.labelTotal.text = "Total payable \(price)"
        } else {
            subscribeView.buttonProduct.layer.borderWidth = 0
            subscribeView.labelTotal.text = "Total payable $ 0.0"
        }
    }
    
    @objc func actionPay() {
        if subscribeView.labelTotal.text == "Total payable $ 0.0" { return } else {
        let product = iapManager.products.first
        print("Product = \(String(describing: product?.price))")
        guard  let identifier = iapManager.products.first?.productIdentifier else { return }
        iapManager.purchase(productWith: identifier)
        }
    }
}

