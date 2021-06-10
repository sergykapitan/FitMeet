//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Combine
import UIKit

class HomeVC: UIViewController,CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if index == 0 {
          //  binding()
        }
        if index == 1 {
          //  bindingRecomandate()
        }
        if index == 2 {
            
        }
    }
    
    
  
    let homeView = HomeVCCode()
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
   // let viewModel = ViewModel()

    
    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.tableView.reloadData()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeTableView()
        homeView.segmentControll.setButtonTitles(buttonTitles: ["Trending","For you","Subscriptions"])
        homeView.segmentControll.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        makeNavItem()
        binding()
        title = "HOME"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

    }
    func makeNavItem() {

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
    }
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               // print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    print("Responce ====== \(response)")
                    self.listBroadcast = response.data!
                    self.homeView.tableView.reloadData()
                }
        })
    }
    
    func bindingRecomandate() {
        takeBroadcast = fitMeetStream.getRecomandateBroadcast()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.homeView.tableView.reloadData()
                }
        })
    }
    
    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseID)
    }

}

