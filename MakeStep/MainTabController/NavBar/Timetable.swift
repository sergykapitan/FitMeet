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
import Kingfisher


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
    var i = 0

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func loadView() {
        super.loadView()
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.tableView.dataSource = self
        profileView.tableView.delegate = self
        profileView.tableView.separatorStyle = .none
        
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
            bundle: Bundle(url: nibUrl!)!)
        self.profileView.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = self.user?.id else { return }
        binding(id: "\(id)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        guard let id = self.user?.id else { return }
        binding(id: "\(id)")
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }

    func binding(id: String) {
        takeBroadcast = fitMeetSream.getBroadcastPrivateTime(status: "PLANNED", userId: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                if response.data != nil  {
                    self.brodcast = response
                    self.profileView.tableView.reloadData()
                  
                }
        })
    }
}

extension Timetable: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = brodcast?.data! else { return 0}
        return sectionData.count
  
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
        
        
        
        let string = brodcast!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "yyyy-MM-dd")
        let dateFormat = "yyyy-MM-dd"

        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = dateFormat
        
        let dateStartStream = dateFormatter.date(from: string)!
        let today = dateFormatter.date(from: Date().getFormattedDate(format: "yyyy-MM-dd"))
        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
        
    
        cell.viewBack.layer.cornerRadius = 6
        cell.viewBack.layer.borderWidth = 1
        cell.viewBack.layer.borderColor = UIColor(hexString: "#B7B7B7").cgColor
        cell.viewBack.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        let str = brodcast!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
        let dateFormatTime = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterTime = DateFormatter()
        
       // dateFormatterTime.dateStyle = .none
        dateFormatterTime.dateFormat = dateFormatTime
        
        let dateStartStreamTime = dateFormatterTime.date(from: str)
        let todayTime = Date() //dateFormatterTime.date(from: Date().getFormattedDate(format: "yyyy-MM-dd"))
        
        cell.lineInfoLabel.textColor = UIColor(hexString: "#B7B7B7")
        
        if dateStartStream < today! {
            cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
            cell.labelDescription.textColor = UIColor(hexString: "#B7B7B7")
            cell.imageLogo.isHidden = true
            cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
            cell.viewBack.backgroundColor = UIColor(hexString: "#F6F6F6")
            cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
            cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
            cell.timeline.backColor = UIColor(hexString: "#3B58A4")
        }
        if dateStartStream > today! {
            cell.imageLogo.isHidden = true
            cell.titleLabel.textColor = .black
            cell.viewBack.backgroundColor = UIColor.white
            cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
            cell.timeline.frontColor = UIColor.clear
            cell.timeline.backColor = UIColor.clear
        }
        if dateStartStream == today! {
            if dateStartStreamTime! >= todayTime {
            cell.labelDescription.textColor = .white
            cell.imageLogo.isHidden = false
            cell.imageLogo.backgroundColor = .red
            cell.imageLogo.makeRounded()
            cell.titleLabel.textColor = UIColor(hexString: "#3B58A4")
            cell.viewBack.backgroundColor = UIColor(hexString: "#3B58A4")
            if i == 0 {
                    cell.timelinePoint = TimelinePoint(color: UIColor(hexString: "#3B58A4"), filled: true)
                    cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
                    cell.timeline.backColor = UIColor.clear
                    i = 1
            } else {
                cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
                cell.timeline.frontColor = UIColor.clear
                cell.timeline.backColor = UIColor.clear
            }
            
            let url = URL(string: brodcast!.data![indexPath.row].previewPath!)
            cell.imageLogo.kf.setImage(with: url)
            } else {
                cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
                cell.labelDescription.textColor = UIColor(hexString: "#B7B7B7")
                cell.imageLogo.isHidden = true
                cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
                cell.viewBack.backgroundColor = UIColor(hexString: "#F6F6F6")
                cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
                cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
                cell.timeline.backColor = UIColor(hexString: "#3B58A4")
            }
        }
        
        
        cell.bubbleEnabled = false
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cell.titleLabel.text = brodcast!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "MMMM d")
        
        cell.labelDescription.font = UIFont.systemFont(ofSize: 12)
        cell.labelDescription.numberOfLines = 3
        cell.labelDescription.text = "\(brodcast!.data![indexPath.row].name!)\n" + "\(brodcast!.data![indexPath.row].description!)"

        cell.lineInfoLabel.text = brodcast!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "h a")
        
        
        cell.viewsInStackView = [UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail"))]

            cell.viewsInStackView = []
            cell.illustrationImageView.image = UIImage(named: "illustration")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = brodcast?.data?[indexPath.section] else { return }
      
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
