//
//  LandscapeVC.swift
//  MakeStep
//
//  Created by Sergey on 26.10.2021.
//

import Foundation
import UIKit
import Combine

class MyTariff: UIViewController,AddFrame {
    
    func addFrame() {
        bindingChannel()
    }
    
    var intHeight = 0.5
    let landscapeView = MytariffVCCode()
    let actionChatTransitionManager = ActionTransishionChatManadger()
    var channel: ChannelResponce?
    
    private var take: AnyCancellable?
    @Inject var fitMeetApi: FitMeetChannels
 
    override func loadView() {
        super.loadView()
        view = landscapeView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        bindingChannel()
        createTableView()
      
    }
    private func actionButton() {
        landscapeView.buttonAddNewMonet.addTarget(self, action: #selector(actionAddMonnet) , for: .touchUpInside)
    }
    @objc func actionAddMonnet() {
        let detailViewController = AddMonetezationVC()
        detailViewController.modalPresentationStyle = .custom
        actionChatTransitionManager.intHeight = intHeight
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
        print(sender.tag)
    }

 
    //MARK: - Selectors
    func bindingChannel() {
        take = fitMeetApi.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if  response.data.last != nil {
                    
                    self.channel = response.data.last
                    self.landscapeView.tableView.reloadData()
              
                }
        })
    }
}

