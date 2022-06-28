//
//  DisableTariffVC.swift
//  MakeStep
//
//  Created by Sergey on 28.06.2022.
//


import Foundation
import UIKit
import Combine
import Loaf

protocol Reload: class {
   func reload()
}

class DisableTariffVC: UIViewController,CustomPresentable {
    var transitionManager: UIViewControllerTransitioningDelegate?
    
       
    let deleteView = DisableTariffCode()
    weak var delagateReload: Reload?
    var idSub: Int?
    var plan: SubPlan?
    var channelId: Int?
    var id: Int?
    
    private var take: AnyCancellable?
    @Inject var fitMeetApi: FitMeetChannels
    
    override func loadView() {
        super.loadView()
        view = deleteView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
    }
    private func actionButton() {
        deleteView.buttonNo.addTarget(self, action: #selector(dissmissView(_:)), for: .touchUpInside)
        deleteView.buttonYes.addTarget(self, action: #selector(deleteTarrif), for: .touchUpInside)
    }
  
    
    @objc func dissmissView(_ sender: UIButton) -> Void  {
        dismiss(animated: true, completion: nil)
    }
    @objc func deleteTarrif()  {
        deleteView.buttonYes.backgroundColor = .blueColor
        deleteView.buttonYes.setTitleColor(UIColor.white, for: .normal)
        
        deleteView.buttonNo.backgroundColor = .clear
        deleteView.buttonNo.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        
        guard let idSub = idSub,let id = id else { return }
        deleteTariff(id: id, delSub: NewSub(newPlans: nil, editSubscriptionPrices: nil, disableSubscriptionPriceIds: [idSub]))
        
//        guard let id = plan?.subscriptionPriceId,let channelId = channelId else { return }
//
//        bindingChannel(id: channelId, sub: NewSub(newPlans: nil, editSubscriptionPrices: [EditSubscriptionPrice(id: id, name: plan?.name, price: plan?.price, periodType: plan?.periodType, periodCount: plan?.periodCount, description: plan?.description, available: false)],
//                                                  disableSubscriptionPriceIds: nil)
//
//       )
    }

//    func bindingChannel(id:Int,sub:NewSub) {
//        take = fitMeetApi.monnetChannels(id: id, sub: sub)
//            .mapError({ (error) -> Error in return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                print("responce = \(response)")
//                var loafStyle = Loaf.State.info
//                loafStyle = Loaf.State.success
//
//
//                if response.message == nil {
//
//                    DispatchQueue.main.async {
//                    Loaf(" Disable ", state: loafStyle, location: .bottom, sender:  self).show(.short) { disType in
//                            switch disType {
//                                     case .tapped: print("Tapped!")
//                                     case .timedOut: self.dismiss(animated: true) {
//                                         self.delagateReload?.reloadTable()
//                            }
//                        }
//                    }
//                }
//            }
//        })
//    }
    
    func deleteTariff(id: Int,delSub: NewSub) {
        take = fitMeetApi.monnetChannels(id: id, sub: delSub)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
                    self.dismiss(animated: true) {
                        self.delagateReload?.reload()
                    }
                }
           })
       }
  
}

