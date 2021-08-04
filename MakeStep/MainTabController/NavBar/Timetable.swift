//
//  Timetable.swift
//  MakeStep
//
//  Created by novotorica on 04.08.2021.
//

import Foundation
import TimelineTableViewCell
import UIKit
import Combine


class Timetable: UIViewController {
    
    

    
    let profileView = TimeTableCode()
    
    private var take: AnyCancellable?
    private var takeChanell: AnyCancellable?
    private var takeBroadcast: AnyCancellable?
    
    
 
    @Inject var fitMeetApi: FitMeetApi
    @Inject var firMeetChanell: FitMeetChannels
    @Inject var fitMeetSream: FitMeetStream
    
    var user: User?
    var brodcast: BroadcastList?

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // TimelinePoint, Timeline back color, title, description, lineInfo, thumbnails, illustration
    let data:[Int: [(TimelinePoint, UIColor, String, String, String?, [String]?, String?)]] = [0:[
            (TimelinePoint(), UIColor.black, "12:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Sun"),
            (TimelinePoint(), UIColor.black, "15:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Sun"),
            (TimelinePoint(color: UIColor.green, filled: true), UIColor.green, "16:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "150 mins", ["Apple"], "Sun"),
            (TimelinePoint(), UIColor.clear, "19:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Moon")
        ], 1:[
            (TimelinePoint(), UIColor.lightGray, "08:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "60 mins", nil, "Sun"),
            (TimelinePoint(), UIColor.lightGray, "09:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "30 mins", nil, "Sun"),
            (TimelinePoint(), UIColor.lightGray, "10:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "90 mins", nil, "Sun"),
            (TimelinePoint(), UIColor.lightGray, "11:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "60 mins", nil, "Sun"),
            (TimelinePoint(color: UIColor.red, filled: true), UIColor.red, "12:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "30 mins", ["Apple", "Apple", "Apple", "Apple"], "Sun"),
            (TimelinePoint(color: UIColor.red, filled: true), UIColor.red, "13:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "120 mins", ["Apple", "Apple", "Apple", "Apple", "Apple"], "Sun"),
            (TimelinePoint(color: UIColor.red, filled: true), UIColor.lightGray, "15:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "150 mins", ["Apple", "Apple"], "Sun"),
            (TimelinePoint(), UIColor.lightGray, "17:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "60 mins", nil, "Sun"),
            (TimelinePoint(), UIColor.lightGray, "18:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "60 mins", nil, "Moon"),
            (TimelinePoint(), UIColor.lightGray, "19:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", "30 mins", nil, "Moon"),
            (TimelinePoint(), backColor: UIColor.clear, "20:00", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", nil, nil, "Moon")
        ]]

    override func loadView() {
        super.loadView()
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButtonContinue()
      //  makeNavItem()
        
       // navigationItem.largeTitleDisplayMode = .always
     
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
            bundle: Bundle(url: nibUrl!)!)
        self.profileView.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.tabBarController?.tabBar.isHidden = false
        makeNavItem()
        binding()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
   
 
    
    func actionButtonContinue() {
     //   profileView.buttonOnline.addTarget(self, action: #selector(actionOnline), for: .touchUpInside)
     //   profileView.buttonOffline.addTarget(self, action: #selector(actionOffline), for: .touchUpInside)
     //   profileView.buttonComing.addTarget(self, action: #selector(actionComming), for: .touchUpInside)

    }

//    func bindingUser() {
//        take = fitMeetApi.getUser()
//            .mapError({ (error) -> Error in return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                if response.username != nil  {
//                    self.user = response
//                    print(self.user)
//                }
//        })
//    }
//
//    func bindingChanell(status: String) {
//        takeChanell = fitMeetSream.getBroadcast(status: status)
//            .mapError({ (error) -> Error in return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                if response.data != nil  {
//                    self.brodcast = response.data?.last
//                    print(self.brodcast)
//                }
//        })
//
//    }
    func binding() {
        takeBroadcast = fitMeetSream.getBroadcast(status: "PLANNED")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               // print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    print("Responce ====== \(response)")
                    self.brodcast = response
                    self.profileView.tableView.reloadData()
                   // self.refreshControl.endRefreshing()
                }
        })
    }
    
    @objc func actionEditProfile() {

    }
    
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "TimeTable"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let backButton = UIButton()
                   backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                   backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

                   let stackView = UIStackView(arrangedSubviews: [backButton ,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

        
        let customTitles = UIBarButtonItem.init(customView: stackView)
        self.navigationItem.leftBarButtonItems = [customTitles]
        
        
        
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]

    }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    
    
    
  

}

extension Timetable: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = data[section] else {
            return 0
        }
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day " + String(describing: section + 1)
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell

        // Configure the cell...
        guard let sectionData = data[indexPath.section] else {
            return cell
        }
        
        let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnails, illustration) = sectionData[indexPath.row]
        var timelineFrontColor = UIColor.clear
        if (indexPath.row > 0) {
            timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        cell.timelinePoint = timelinePoint
        cell.timeline.frontColor = timelineFrontColor
        cell.timeline.backColor = timelineBackColor
        cell.titleLabel.text = title
        cell.descriptionLabel.text = description
        cell.lineInfoLabel.text = lineInfo
        
        if let thumbnails = thumbnails {
            cell.viewsInStackView = thumbnails.map { thumbnail in
                return UIImageView(image: UIImage(named: thumbnail))
            }
        }
        else {
            cell.viewsInStackView = []
        }

        if let illustration = illustration {
            cell.illustrationImageView.image = UIImage(named: illustration)
        }
        else {
            cell.illustrationImageView.image = nil
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = data[indexPath.section] else {
            return
        }
        
        print(sectionData[indexPath.row])
    }


}
