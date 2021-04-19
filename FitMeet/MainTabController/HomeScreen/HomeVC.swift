//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import Foundation
import UIKit
import AVKit

class HomeVC: UIViewController {
    
    var videos: [Video] = []
    let homeView = HomeVCCode()
   // let viewModel = ViewModel()
    //? Add the video looper view
    let videoPreviewLooper = VideoLooperView(clips: VideoClip.allClips())
    
    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        loadViews()
  
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //? Start the looping video player when the view appears
      videoPreviewLooper.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

      //? Make sure it's paused when the user leaves this screen
      videoPreviewLooper.pause()
    }
    func loadViews() {
      view.backgroundColor = .white
      view.addSubview(homeView.tableView)
      view.addSubview(videoPreviewLooper)
    }
    
    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(HomeTableviewCell.classForCoder(), forCellReuseIdentifier: HomeTableviewCell.reuseID)
    }

}

