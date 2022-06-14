//
//  DeleteTariffVC.swift
//  MakeStep
//
//  Created by Sergey on 07.11.2021.
//

import Foundation
import UIKit
import Combine

protocol ReloadTable: class {
   func reloadTable()
}

class DeleteTariffVC: UIViewController {
       
    let deleteView = DeleteTariffVCCode()
    weak var delagateReload: ReloadTable?
    var color: UIColor?
    var idSub: Int?
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
        view.backgroundColor = color
      
    }
    private func actionButton() {
        deleteView.buttonNo.addTarget(self, action: #selector(dissmissView(_:)), for: .touchUpInside)
        deleteView.buttonYes.addTarget(self, action: #selector(deleteTarrif), for: .touchUpInside)
    }
  
    
    @objc func dissmissView(_ sender: UIButton) -> Void  {
        dismiss(animated: true, completion: nil)
    }
    @objc func deleteTarrif()  {
        deleteView.buttonYes.backgroundColor = UIColor(hexString: "#3B58A4")
        deleteView.buttonYes.setTitleColor(UIColor.white, for: .normal)
        
        deleteView.buttonNo.backgroundColor = .clear
        deleteView.buttonNo.setTitleColor(UIColor(hexString: "#3B58A4"), for: .normal)
        
        guard let idSub = idSub,let id = id else { return }
        deleteTariff(id: id, delSub: NewSub(newPlans: nil, editSubscriptionPrices: nil, disableSubscriptionPriceIds: [idSub]))
       
    }
    func deleteTariff(id: Int,delSub: NewSub) {
        take = fitMeetApi.monnetChannels(id: id, sub: delSub)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
                    self.dismiss(animated: true) {
                        self.delagateReload?.reloadTable()
                    }
                }
           
        })
    }
  
}

