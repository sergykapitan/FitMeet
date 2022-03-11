//
//  MainTabViewController.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//


import UIKit
import Alamofire
import Combine
import BottomPopup

class StreamingVC: BottomPopupViewController {
    
    let streamView = StreamingVCCode()
    @Inject var fitMeetStream: FitMeetStream
    @Inject var fitMeetChanell: FitMeetChannels
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    
    let channelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    let userId = UserDefaults.standard.string(forKey: Constants.userID)
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    
    let date = Date()
    private var take: AnyCancellable?
    private var takeChannel: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
   
    private var chanellName: String?
    private var titleChanell: String?
    private var descriptionChanell: String?
    var listBroadcast: [BroadcastResponce] = []
    var listChanell: [ChannelResponce] = []
    var broadcast:  BroadcastResponce?
    
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var popupDimmingViewAlpha: CGFloat { return 0.5 }
    
    override func loadView() {
        super.loadView()
        view = streamView
        view.backgroundColor = .white
    //    self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            actionButton()
            bindingChanell()

        if channelId == nil {
            createNavBar()
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
            
            makeTableView()
            print("UserID ======\(userId)")
            print("TOKEN ++++++\(token)")
            guard let usId = userId else { return }
           // binding(idUser: usId)
           
            self.navigationItem.title = "Chanell List"
            view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    }
    
    func actionButton() {
      
    }
    func binding(idUser:String) {
//        takeChannel = fitMeetStream.getListBroadcast(id: idUser)
//            .mapError({ (error) -> Error in return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                print("RESPONCE ====== \(response)")
//                if response.data != nil  {
//                    self.listBroadcast = response.data!
//                    //self.streamView.tableView.reloadData()
//                }
//        })
    }
    func bindingChanell() {
        takeChannel = fitMeetChanell.listChannels()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listChanell = response.data                    
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
        let alertController = UIAlertController(title: "Chanell Name", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {_ in
            guard let name = alertController.textFields?.first?.text , let description = alertController.textFields?[1].text, let title = alertController.textFields?[2].text  else { return }

            self.chanellName = name
            self.descriptionChanell = description
            self.titleChanell = title

           // self.nextView(chanellId: 29, name: name)
            self.fetchChannel(name: name, title: title, description: description)
        }
        
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Chanell name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter Chanell description..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter Chanell title..."
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

    func nextView(chanellId: Int ,name: String )  {
       
        takeChannel = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(
                                                    channelID: chanellId,
                                                    name: name,
                                                    type: "STANDARD",
                                                    access: "ALL",
                                                    hasChat: true,
                                                    isPlanned: true,
                                                    onlyForSponsors: false,
                                                    onlyForSubscribers: false,
                                                    categoryIDS: [],
                                                    scheduledStartDate: "2021-05-20T08:54:08.006Z",
                                                    description: "sssss",
                                                    previewPath: "/path/to/file.jpg"))
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print("Responce ==== \(response.id)")
                if let id = response.id  {
                    print("greate broadcast")
                    guard let usId = self.userId else { return }
                    print(response.id)
                    self.broadcast = response

                }
             })
         
         }

func fetchChannel(name: String,title: String,description: String) {
    takeChannel = fitMeetChanell.createChannel(channel:  ChannelRequest(name: name, title: title, description: description, favoriteCategoryIds: [25] , backgroundUrl: "https://static.fitliga.com/jyyRD5yf2tuv", facebookLink: "https://facebook.com/jyyRD5yf2tuv", instagramLink: "https://instagram.com/jyyRD5yf2tuv", twitterLink: "https://twitter.com/jyyRD5yf2tuv"))
         .mapError({ (error) -> Error in
                     return error })
         .sink(receiveCompletion: { _ in }, receiveValue: { response in
             if let idChanell = response.id {
                 UserDefaults.standard.set(idChanell, forKey: Constants.chanellID)
                 self.bindingChanell()
      
                }
             })
          }
}
