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
    
    var ddd:[String: Any]?
    
    var data:[Int: [(TimelinePoint, UIColor, String, String, String?, [String]?, String?)]]
        
        
        = [0:[
        (TimelinePoint(), UIColor.black, "12:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Sun"),
        (TimelinePoint(), UIColor.black, "15:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", nil, nil, "Sun"),
            
        (TimelinePoint(color: UIColor(hexString: "#3B58A4"), filled: true), UIColor(hexString: "#3B58A4"), "16:30", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "150 mins", ["Apple"], "Sun"),
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

    }

    func binding() {
        takeBroadcast = fitMeetSream.getBroadcast(status: "PLANNED")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
               // print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    self.brodcast = response
                     
                    guard let f = response.data?.first else { return }
                    
                    self.ddd = f.asDictionary()
                   // print("HJBHBJJBJBJH++++++++\(ddd)")
                    let key =  ddd?.values
                  //  print(key?.debugDescription)
                 //   let g = key
//                    self.data = [0:[
//
//
//                        (TimelinePoint(),
//                              UIColor(hexString: "#3B58A4"),
//                              f.scheduledStartDate!.getFormattedDate(format: "HH:mm:ss"),
//                              f.name!,
//                              f.scheduledStartDate?.getFormattedDate(format: "MMM d"),
//                              ["aaa","ddd","fffff","fff????"],
//                              "hhhhhhh?????")
//
//
//
//
//
//
//
//
//
//
//                    ]]

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
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    
    
    
  

}

extension Timetable: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       // return data.count
       // return ddd?.count ?? 0
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       // guard let sectionData = data[section] else { return 0}
        guard let sectionData = brodcast?.data! else { return 0}
       // guard let datas = ddd? else { return 0}
        
       // print("DATTTAS = \(datas)")
 
      //,let datas = ddd[section]
     //   guard let sectionDatas = datas[section] else { return 0}
     //   guard let d = datas[section] else { return 0}
        
        return sectionData.count
       return 7
        
      //  return ddd?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var date = Date()
        let calendar = Calendar.current
        
        var c = TimeInterval(7)
        
       // print(calendar.nextWeekend(startingAfter: date, start: &date, interval: &c))
        return "August " + String(describing: section + 1)
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell

        // Configure the cell...
        guard let sectionData = data[indexPath.section] else { return cell }
       // guard let sectionData2 = ddd[indexPath.section] else { return cell}
        
        
        
        guard let dataArr = ddd else { return cell}
     //   print("KKKKKKKKKKK====\(dataArr["name"])")
      
        
     //   let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnails, illustration) = sectionData[indexPath.row]
     //   let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnails, illustration) = (dataArr)[indexPath.row]
        
        
      //  print("gknfdnvefnvenverono====\(sectionData2[indexPath.row])")
        
        var timelineFrontColor = UIColor.clear
        
        if (indexPath.row > 0) {
           // timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        let key = Array(dataArr)[indexPath.row].key
        let array = dataArr[key]
       // print(array)
       // let value = array[indexPath.row]
        
        let gg =  Array(dataArr)// or .value
        
        print("GGGGGGG=\(gg[indexPath.section])")
        
        let ggg =  Array(dataArr)[indexPath.row] // or .value
        
        print("hhhhhhhhh=\(ggg)")
        
        
//        var dict = [String: [Int]]()
//
//        dict.updateValue([1, 2, 3], forKey: "firstKey")
//        dict.updateValue([3, 4, 5], forKey: "secondKey")
//
//        var keyIndex = ["firstKey": "firstKey", "secondKey": "secondKey"]
//        var arr = [[String: [Int]]]()
//
//        for (key, value) in dict {
//            arr.append([keyIndex[key]!: value])
//        }
//
//        print(arr[0]) // ["firstKey": [1, 2, 3]]
        
        cell.timelinePoint = TimelinePoint(color: UIColor.red, filled: true)
        cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
        cell.timeline.backColor = UIColor(hexString: "#3B58A4")
        cell.titleLabel.text = "title"
        cell.descriptionLabel.text = dataArr["name"] as! String
        
      //  let date = dataArr["scheduledStartDate"] as! String
      //  print("HHHHHHHHH=\(date)")
        
        
        
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = "MMM d"
//        let d = dateformat.date(from: date)
//        print("DATE =\(d)")
//        guard let getDate = d else { return cell}
//        let c = dateformat.string(from: getDate)
//        print("CATT=\(c)")
        
        cell.lineInfoLabel.text = "`hhhh"
        
//        if let thumbnails = "thumbnails" {
        
        cell.viewsInStackView = [UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail"))]
        
 //            thumbnails.map { thumbnail in
  //              return UIImageView(image: UIImage(named: thumbnail))
//            }
//        }
      //  else {
            cell.viewsInStackView = []
     //   }

//        if let illustration = illustration {
            cell.illustrationImageView.image = UIImage(named: "illustration")
//        }
//        else {
  //          cell.illustrationImageView.image = nil
      //  }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = brodcast?.data?[indexPath.section] else {
            return
        }
        
        print(sectionData.name?[indexPath.row])
    }


}
