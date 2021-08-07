//
//  CategoryVC.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit
import Foundation
import CoreData
import Combine



class CategoryVC: UIViewController, UISearchBarDelegate {
    

    var isSearchBarEmpty: Bool {
        navigationItem.searchController = searchController
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @Inject var fitMeetStream: FitMeetStream
    
    private var takeBroadcast: AnyCancellable?
    private var takeCategory: AnyCancellable?
    private var unCategory: AnyCancellable?
    
    var listBroadcast: [Datum] = []
    var filtredBroadcast: [Datum] = []
    let searchView = CategoryCode()
    var categories: [Int: String] = [:]
   // let viewModel = ViewModel()
    
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifiCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        makeNavItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }

    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        binding()
        actionButton()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // searchView.scrollView.contentSize = CGSize(width: searchView.stackHFirst.frame.width, height: searchView.stackHFirst.frame.height)
    }
    
    func actionButton() {
        searchView.buttonAll.addTarget(self, action: #selector(actionAll), for: .touchUpInside)
        searchView.buttonPopular.addTarget(self, action: #selector(actionPopular), for: .touchUpInside)
        searchView.buttonNew.addTarget(self, action: #selector(actionNew), for: .touchUpInside)
        searchView.buttonLikes.addTarget(self, action: #selector(actionLikes), for: .touchUpInside)
        searchView.buttonViewers.addTarget(self, action: #selector(actionViewers), for: .touchUpInside)

    }

    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Category"
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
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func notificationHandAction() {
        print("notificationHandAction")
    }
    @objc func actionAll() {
        searchView.buttonAll.backgroundColor = UIColor(hexString: "#3B58A4")
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonLikes.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")

        filtredBroadcast = listBroadcast
        self.searchView.collectionView.reloadData()
    }
    @objc func actionPopular() {
        
        searchView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#3B58A4")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonLikes.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")
        
        
        
        filtredBroadcast = listBroadcast.filter { $0.isPopular }
        self.searchView.collectionView.reloadData()
    }
    @objc func actionNew() {
        
        searchView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#3B58A4")
        searchView.buttonLikes.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")
        
        
        filtredBroadcast = listBroadcast.filter { $0.isNew }
        self.searchView.collectionView.reloadData()
    }
    @objc func actionLikes() {
        
        searchView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonLikes.backgroundColor = UIColor(hexString: "#3B58A4")
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")
        
        
        filtredBroadcast = listBroadcast.filter { $0.isFollow ?? false}
        self.searchView.collectionView.reloadData()
    }
    @objc func actionViewers() {
        
        searchView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonLikes.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#3B58A4")
      
        filtredBroadcast = listBroadcast.filter{ $0.followersCount > 1}
    }

    private func setupMainView() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
    }
    func makeReguest(searchText: String) {
       // searchView.showSpinner()
    }
    func stopSpiners() {
        refreshControl.endRefreshing()
    }
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        print("refrech")
       }
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
            guard let id = filtredBroadcast[sender.tag].id else { return }
            followCategory(id: id)
            binding()
            self.searchView.collectionView.reloadData()
        } else {
            sender.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
            guard let id = filtredBroadcast[sender.tag].id else { return }
            unFollowCategory(id: id)
            binding()
            self.searchView.collectionView.reloadData()
        }
        
        }
    
    func binding() {
        takeBroadcast = fitMeetStream.getCategoryPrivate()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = response.data!
                    self.searchView.collectionView.reloadData()
                }
        })
    }
    func followCategory(id: Int) {
        takeCategory = fitMeetStream.followCategory(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
                    print("goodFolow")
                   // self.searchView.collectionView.reloadData()
                  
            }
        })
    }
    func unFollowCategory(id: Int) {
        unCategory = fitMeetStream.unFollowCategory(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
                    print("goodFolow")
                   // self.searchView.collectionView.reloadData()
                  
            }
        })
    }
}