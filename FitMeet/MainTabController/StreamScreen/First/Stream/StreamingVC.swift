//
//  MainTabViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//


import UIKit
import Alamofire
import Combine

class StreamingVC: UIViewController {
    
    let streamView = StreamingVCCode()
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    
    let date = Date()
    private var take: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    
    private var streamName: String?
    private var titleStream: String?
    private var descriptionStream: String?
    
    
    override func loadView() {
        super.loadView()
        view = streamView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // tabBarController?.tabBar.backgroundColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            actionButton()
            createNavBar()
           makeTableView()
    }
    
    func actionButton() {
      
    }
    private func makeTableView() {
        streamView.tableView.dataSource = self
        streamView.tableView.delegate = self
        streamView.tableView.register(StreamingViewCell.self, forCellReuseIdentifier: StreamingViewCell.reuseID)
    }
    func createNavBar() {
        let button = UIButton(type: .custom) as? UIButton
        button?.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
        button?.addTarget(self, action:#selector(addStream), for:.touchUpInside)
        button?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button!)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addStream() {
        let alertController = UIAlertController(title: "Stream", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {_ in
            
            guard let name = alertController.textFields?.first?.text else { return }
            guard let title = alertController.textFields?[1].text else { return }
            guard let description = alertController.textFields?[2].text else { return }
            
            self.streamName = name
            self.titleStream = title
            self.descriptionStream = description
            
        }
        
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Stream name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter Title name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter  Description..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        alertController.addAction(addAction);
        alertController.addAction(cancelAction);
        
        present(alertController, animated: true, completion: nil)
    }
            @objc private func handleTextChanged(_ sender: UITextField) {
                
                guard let alertController = presentedViewController as? UIAlertController,
                      let addAction = alertController.actions.first,
                      let text = sender.text
                else { return }
                
                addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
            }

    @objc func nextView() {
        guard let name = streamName, let title = titleStream, let description = descriptionStream else { return }
        takeChannel = fitMeetChanell.createChannel(channel: ChannelRequest(name: name, title: title, description: description , backgroundUrl: "https://static.fitliga.com/jyyRD5yf2tuv", facebookLink: "https://facebook.com/jyyRD5yf2tuv", instagramLink: "https://instagram.com/jyyRD5yf2tuv", twitterLink: "https://twitter.com/jyyRD5yf2tuv"))
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id  {
                    guard let name = self.streamName else { return }
                }
        })
        take = fitMeetStream.startStremId(id: 4)
        .mapError({ (error) -> Error in
                    print("ERROR +++++++ \(error.self)")
                    return error })
        .sink(receiveCompletion: { _ in }, receiveValue: { response in
            print(response.token)
            if response.url != nil {
            }
          })
       }
   
}
