//
//  SubscribeVC.swift
//  MakeStep
//
//  Created by novotorica on 20.08.2021.
//

import Foundation
import UIKit
import Combine

protocol VeritiPurchase: class {
   func addPurchase()
}

class SubscribeVC: UIViewController, VeritifProduct {
    
    func addPurchase() {
        dismiss(animated: true) {
            self.delagatePurchase?.addPurchase()
        }
    }
    
    
    let subscribeView = SubscribeVCCode()
    let iapManager = IAPManager.shared
    
    @Inject var fitMeetApi: FitMeetApi
    private var takeProduct: AnyCancellable?
    
    @Inject var fitMeetChannel: FitMeetChannels
    private var take: AnyCancellable?
    
    var channel: ChannelResponce?
    weak var delagatePurchase: VeritiPurchase?
    var id: Int?
    
    override func loadView() {
        view = subscribeView
        self.view.backgroundColor = UIColor.white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let i = view.frame.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
      
    }
    
    private func actionButton() {
        subscribeView.buttonProduct.addTarget(self, action: #selector(selectProduct), for: .touchUpInside)
        subscribeView.buttonPay.addTarget(self, action: #selector(actionPay), for: .touchUpInside)
        subscribeView.buttonTermsServise.addTarget(self, action: #selector(actionTerms), for: .touchUpInside)
        subscribeView.buttonPrivacyPolicy.addTarget(self, action: #selector(actionPrivacyPolicy), for: .touchUpInside)
    }
    
    @objc private func selectProduct() {
        subscribeView.buttonProduct.isSelected.toggle()
        if subscribeView.buttonProduct.isSelected {
        guard let id = id else { return  }

        bindingUser(id: id)
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
        guard let id = channel?.id else { return }
        if subscribeView.labelTotal.text == "Total payable $ 0.0" { return } else {
        let product = iapManager.products.first
        IAPManager.shared.delagateFrame = self
        guard  let identifier = iapManager.products.first?.productIdentifier else { return }
            iapManager.purchase(productWith: identifier, channelId: "\(id)")
        }
    }
    func bindingUser(id: Int) {
        take = fitMeetChannel.listChannelsPrivate(idUser: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print(response)
                if response.data.first?.name != nil  {
                    self.channel = response.data.first
                }
        })
    }
    func bindingAppleProduct() {
        takeProduct = fitMeetApi.getAppProduct()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data.first != nil  {     
                }
            })
        }
    @objc func actionTerms() {
        
        let helpWebViewController = WebViewController()
        helpWebViewController.url = Constants.webViewPwa + "terms_of_service"
        present(helpWebViewController, animated: true, completion: nil)       
    }
    @objc func actionPrivacyPolicy() {
       let helpWebViewController = WebViewController()
       helpWebViewController.url = Constants.webViewPwa + "privacy_policy"
       present(helpWebViewController, animated: true, completion: nil)
    }
}

