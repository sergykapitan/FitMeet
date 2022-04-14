//
//  SearchVC.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import Foundation
import CoreData
import Combine


class SearchVC: UIViewController ,SegmentControlSearchDelegate  {
    
    let videoVC = SearchVideoVC()
    let coachVC = SearchUserVC()
    let categoriesVC = SearchCategory()
    
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    var index: Int = 0
 
    func change(to index: Int) {
        if index == 0 {
           actionVideo()
            self.index = index
        }
        if index == 1 {
           actionCoach()
            self.index = index
        }
        if index == 2 {
           actionCategory()
            self.index = index
        }
    }
    let searchView = SearchVCCode()
    private let searchController = UISearchController(searchResultsController: nil)
    
// MARK: - LifiCicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchView.segmentControll.setIndex(index: self.index)
        searchView.segmentControll.anchor(top: self.navigationItem.searchController?.searchBar.bottomAnchor, left: searchView.cardView.leftAnchor, paddingTop: 10, paddingLeft: 20, height: 30)

    }
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavItem()
        searchView.segmentControll.setButtonTitles(buttonTitles: ["Video","Coaches","Categories"])
        searchView.segmentControll.delegate = self
        actionVideo()
        setupSearchBar()
    }
// MARK: - Metods
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Coaches, Streams or Categories"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsScopeBar = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.isActive = false
        self.searchController.searchBar.isTranslucent = false
    }
//MARK: - Selectors
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Search"
                   titleLabel.textAlignment = .center
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(notificationHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
       // self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    @objc func actionVideo() {
        removeAllChildViewController(coachVC)
        removeAllChildViewController(categoriesVC)
        configureChildViewController(videoVC, onView: searchView.selfView )

    }
    @objc func actionCoach() {
        removeAllChildViewController(videoVC)
        removeAllChildViewController(categoriesVC)
        configureChildViewController(coachVC, onView: searchView.selfView )
    }
    @objc func actionCategory() {
        removeAllChildViewController(videoVC)
        removeAllChildViewController(coachVC)
        configureChildViewController(categoriesVC, onView: searchView.selfView )
    }
}
//MARK: - UISearchBarDelegate
extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if searchBar.text == "" {
            print("SearchText == \(searchBar.text)")
        } else {
        videoVC.searchVideo(text: searchBar.text!)
        coachVC.searchUser(text: searchBar.text!)
        categoriesVC.searchCategory(text: searchBar.text!)
        }
    }
    func connectUser (broadcastId:String?,channellId: String?) {
        
        guard let broadID = broadcastId,let id = channellId else { return }
        SocketWatcher.sharedInstance.getTokenChat()
        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
    }

}
extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked( _ searchBar: UISearchBar) {
    token != nil ?  videoVC.bindingRec() :  videoVC.bindingNotAuth(name: "a")
    coachVC.getUsers(name: "a")
    categoriesVC.getAllCategory()
    }
}
