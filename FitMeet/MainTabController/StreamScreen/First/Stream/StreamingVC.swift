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
    var viewModel  = StreamViewModel()
    
    let channelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    let userId = UserDefaults.standard.string(forKey: Constants.userID)
    
    let date = Date()
    private var take: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
   
    private var streamName: String?
    private var titleStream: String?
    private var descriptionStream: String?
    var listBroadcast: [BroadcastResponce] = []
    
    override func loadView() {
        super.loadView()
        view = streamView
        view.backgroundColor = .white
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // tabBarController?.tabBar.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            actionButton()
            createNavBar()
            makeTableView()
            guard let usId = userId else { return }
            binding(idUser: usId)
           // title = "Broadcast"
        self.navigationController?.navigationItem.title = "Broadcast"
    }
    
    func actionButton() {
      
    }
    func binding(idUser:String) {
        takeChannel = fitMeetStream.getListBroadcast(id: idUser)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data
                    self.streamView.tableView.reloadData()
                }
        })
    }
    
    
    
    
    private func makeTableView() {
        streamView.tableView.dataSource = self
        streamView.tableView.delegate = self
        streamView.tableView.register(StreamingViewCell.self, forCellReuseIdentifier: StreamingViewCell.reuseID)
    }
    func createNavBar() {
        let button = UIButton(type: .custom) as? UIButton
        let origImage = UIImage(named: "Settings")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button?.setImage(tintedImage, for: .normal)
        button?.tintColor = .gray
        button?.addTarget(self, action:#selector(addBroadcast), for:.touchUpInside)
        button?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button!)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addBroadcast() {
        let alertController = UIAlertController(title: "Broadcast Name", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {_ in
            
            guard let name = alertController.textFields?.first?.text else { return }

            self.streamName = name
            guard let chanellId = self.channelId else { return }
            
            let IntIdChanell = Int(chanellId)
            guard let iDchanell = IntIdChanell else { return }
            self.nextView(chanellId: iDchanell, name: name)
        }
        
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Broadcast name..."
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

    func nextView(chanellId: Int ,name: String ) {
        takeChannel = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(channelID: chanellId, name: name, type: "STANDARD", access: "ALL", hasChat: true, isPlanned: true, onlyForSponsors: false, onlyForSubscribers: false, categoryIDS: [1], scheduledStartDate: "2021-05-03T08:54:08.006Z"))
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if let id = response.id  {
                    print("greate broadcast")
                    guard let usId = self.userId else { return }
                    self.binding(idUser: usId)
                }
        })
    }
}
