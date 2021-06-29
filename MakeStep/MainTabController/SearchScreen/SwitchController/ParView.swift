//
//  ParView.swift
//  FitMeet
//
//  Created by novotorica on 16.06.2021.
//

import Foundation
import UIKit

protocol SearchTexttoVC : class {
    func onChangeText()
}




class ParView: UIViewController {
    
    
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    let searchView = ParentControllwerCode()
    var currentViewController: UIViewController?
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    weak var delegate: SearchTexttoVC!
    
    
    lazy var firstChildTabVC: UIViewController? = {
      //  let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewControllerId")
        let firstChildTabVC = FirstVC()
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
      //  let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewControllerId")
        let secondChildTabVC = HomeVC()
        return secondChildTabVC
    }()
    
    // MARK: - View Controller Lifecycle
    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.segmentControll.initUI()
        searchView.segmentControll.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        searchView.segmentControll.addTarget(self, action: #selector(segContr), for: .valueChanged)
        searchView.segmentControll.selectedSegmentIndex = 0
        makeNavItem()
        setupSearchBar()
       // searchView.segmentControll.anchor(top: self.navigationItem.searchController?.searchBar.bottomAnchor, left: searchView.cardView.leftAnchor, paddingTop: 10, paddingLeft: 20, height: 30)
    }
    @objc func segContr(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Coaches, Streams or Categories"
        searchController.searchBar.delegate = self
    }
//    func filterContentForSearchText(_ searchText: String,category: BroadcastResponce? = nil) {
//
//        filtredBroadcast = listBroadcast.filter { (candy: BroadcastResponce) -> Bool in
//            return (candy.name?.lowercased().contains(searchText.lowercased()) ?? true)
//          }
//
//        searchView.tableView.reloadData()
//    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Search"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    @objc func rightHandAction() {
        print("right bar button action")
    }
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.searchView.contentView.bounds
            self.searchView.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
        return nil
        }
    
        return vc
    }
    
    
}

extension ParView: UISearchResultsUpdating,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
     
            let searchBar = searchController.searchBar
            print(searchBar.text)
            self.delegate?.onChangeText()
           // filterContentForSearchText(searchBar.text!)
        
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        print(searchText)
        self.delegate?.onChangeText()
        navigationItem.searchController?.isActive = false
        
    }
}
