//
//  TimetableVC.swift
//  MakeStep
//
//  Created by Sergey on 01.12.2021.
//

import Foundation
import UIKit
import Combine
import AudioToolbox
import TimelineTableViewCell

class TimetableVC: UIViewController {

   
    let timeTableView = TimetableVCCode()
    var brodcast: BroadcastList?
  
    override func loadView() {
        super.loadView()
        view = timeTableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    private func makeTableView() {
        timeTableView.tableView.dataSource = self
        timeTableView.tableView.delegate = self
        timeTableView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
        timeTableView.tableView.register(PlayerViewCell.self, forCellReuseIdentifier: PlayerViewCell.reuseID)
        timeTableView.tableView.separatorStyle = .none
        let bundle = Bundle(for: TimelineTableViewCell.self)
        let nibUrl = bundle.url(forResource: "TimelineTableViewCell", withExtension: "bundle")
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell",
            bundle: Bundle(url: nibUrl!)!)
        self.timeTableView.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
    }

    //MARK: - Selectors
    private func vibrate() {
        if #available(iOS 10.0, *) {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

