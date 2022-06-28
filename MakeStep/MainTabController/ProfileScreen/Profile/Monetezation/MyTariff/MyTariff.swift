//
//  LandscapeVC.swift
//  MakeStep
//
//  Created by Sergey on 26.10.2021.
//

import Foundation
import UIKit
import Combine
import AudioToolbox

class MyTariff: UIViewController,AddFrame, ReloadTable,Reload {
    func reload() {
        guard let userId = userId else { return }
        bindingChannel(userId: Int(userId)!)
    }
    
    
    func reloadTable() {
        guard let userId = userId else { return }
        bindingChannel(userId: Int(userId)!)
    }
    
    
    func addFrame() {
        guard let userId = userId else { return }
        bindingChannel(userId: Int(userId)!)
    }
    
    var intHeight = 0.5
    let landscapeView = MytariffVCCode()
    let actionChatTransitionManager = ActionTransishionChatManadger()
    var channel: ChannelResponce?
    let userId = UserDefaults.standard.string(forKey: Constants.userID)
    
    private var take: AnyCancellable?
    @Inject var fitMeetApi: FitMeetChannels
 
    override func loadView() {
        super.loadView()
        view = landscapeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        guard let userId = userId else { return }
        bindingChannel(userId: Int(userId)!)
        createTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    private func actionButton() {
        landscapeView.buttonAddNewMonet.addTarget(self, action: #selector(actionAddMonnet) , for: .touchUpInside)
    }
    @objc func actionAddMonnet() {
        let detailViewController = AddMonetezationVC()
        detailViewController.modalPresentationStyle = .custom
        if view.bounds.height <= 488 {
            actionChatTransitionManager.intHeight = 0.6
        } else {
            actionChatTransitionManager.intHeight = 0.5
        }
        
        actionChatTransitionManager.intWidth = 1
        detailViewController.transitioningDelegate = actionChatTransitionManager
        detailViewController.color = .white
        detailViewController.delagateFrame = self
        detailViewController.channelId = self.channel?.id
        present(detailViewController, animated: true)
    }
      
    private func createTableView() {
        landscapeView.tableView.dataSource = self
        landscapeView.tableView.delegate = self
        landscapeView.tableView.register(TarrifCell.self, forCellReuseIdentifier: TarrifCell.reuseID)
        landscapeView.tableView.separatorStyle = .none
        landscapeView.tableView.showsVerticalScrollIndicator = false
    }
    
    @objc func deleteCell(_ sender: UIButton) -> Void  {
        guard let id = self.channel?.subscriptionPlans?[sender.tag] else { return }
        let detailViewController = DeleteTariffVC()
        detailViewController.id = self.channel?.id
        detailViewController.idSub = id.subscriptionPriceId
        detailViewController.delagateReload = self
        self.present(detailViewController, interactiveDismissalType: .standard)

    }
    @objc func actionEditMonnet(_ sender: UIButton) {
        guard let id = self.channel?.subscriptionPlans?[sender.tag] else { return }
        let detailViewController = EditMonetVC()
        detailViewController.modalPresentationStyle = .custom
        if view.bounds.height <= 488 {
            actionChatTransitionManager.intHeight = 0.6
        } else {
            actionChatTransitionManager.intHeight = 0.5
        }
        actionChatTransitionManager.intWidth = 1
        detailViewController.transitioningDelegate = actionChatTransitionManager
        detailViewController.color = .white
        detailViewController.delagateFrame = self
        detailViewController.channelId = self.channel?.id
        detailViewController.id = id
        present(detailViewController, animated: true)
    }
    @objc func actionisableonnet(_ sender: UIButton) -> Void {
        guard let plan = self.channel?.subscriptionPlans?[sender.tag] else { return }
        let disableVC = DisableTariffVC()
        disableVC.channelId = self.channel?.id
        disableVC.id = self.channel?.id
        disableVC.delagateReload = self
        disableVC.idSub = plan.subscriptionPriceId
        disableVC.plan = plan
        self.present(disableVC, interactiveDismissalType: .standard)
 
    }

 
    //MARK: - Selectors
    func bindingChannel(userId: Int) {
        take = fitMeetApi.listChannelsPrivate(idUser: userId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if  response.data.last != nil {                    
                    self.channel = response.data.last
                    self.landscapeView.tableView.reloadData()
              
                }
            })
        }
    
}

