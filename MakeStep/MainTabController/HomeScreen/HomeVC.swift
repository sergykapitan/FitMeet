//
//  HomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Combine
import UIKit

// Only class object can conform to this protocol (struct/enum can't)
protocol YoutuberTableViewCellDelegate: AnyObject {
  func youtuberTableViewCell(_ youtuberTableViewCell: HomeCell, subscribeButtonTappedFor youtuber: String)
}

class HomeVC: UIViewController,CustomSegmentedControlDelegate,UITabBarControllerDelegate {
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if index == 0 {
            binding()
            self.homeView.tableView.reloadData()
        }
        if index == 1 {
            bindingRecomandate()
            self.homeView.tableView.reloadData()
        }
        if index == 2 {
            
        }
    }
    
    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

  
    let homeView = HomeVCCode()
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
    var  playerContainerView: PlayerContainerView?

    
    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       // homeView.tableView.reloadData()
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
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate

    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Home"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Note"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        tvc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(tvc, animated: true)
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    
    @objc func editButtonTapped(_ sender: Any, event: Any) -> Void {
        let point : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: homeView.tableView)
        var indexPath =  self.homeView.tableView.indexPathForRow(at: point)
                if let btnlike = sender as? UIButton{
                    if btnlike.isSelected{
                        btnlike.isSelected = false
                    }else{
                        btnlike.isSelected = true
                    }

        }
        
        }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        print("refrech")
        binding()
       }
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               // print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    print("Responce ====== \(response)")
                    self.listBroadcast = response.data!
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
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

