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
    
    
    @Inject var fitMeetStream: FitMeetStream
    
    private var takeBroadcast: AnyCancellable?
    private var takeCategory: AnyCancellable?
    private var unCategory: AnyCancellable?
    
    var listBroadcast: [Datum] = []
    var filtredBroadcast: [Datum] = []
    let searchView = CategoryCode()
    var categories: [Int: String] = [:]
  
    let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)
    
    // MARK: - LifiCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        makeNavItem()
        if Connectivity.isConnectedToInternet {
            return } else {
                let vc = NotInternetView()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationCapturesStatusBarAppearance = true
                vc .delegate = self
                self.present(vc, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.navigationBar.isTranslucent = false
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
        if token != nil {
            binding()
            self.searchView.buttonLikes.isHidden = false
        } else {
            bindingNotAuth()
            self.searchView.buttonLikes.isHidden = true
        }
    }

    override func loadView() {
        super.loadView()
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        actionButton()

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
    @objc func actionAll() {
        searchView.buttonAll.backgroundColor = UIColor(hexString: "#3B58A4")
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonLikes.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")
        if token != nil {
            binding()
        } else {
            bindingNotAuth()
        }
        
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
        if token != nil {
           bindingLikes()
        } else {
          bindingLikesNot()
        }
        
       
    }
    @objc func actionViewers() {
        
        searchView.buttonAll.backgroundColor = .blueColor
        searchView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        searchView.buttonLikes.backgroundColor = .blueColor
        searchView.buttonViewers.backgroundColor = UIColor(hexString: "#3B58A4")
        filtredBroadcast = listBroadcast.filter{ $0.followersCount > 1}
    }

    private func setupMainView() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
    }
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    //MARK: - Selectors
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return }

        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
            guard let id = filtredBroadcast[sender.tag].id else { return }
            followCategory(id: id)
           
        } else {
            sender.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
            guard let id = filtredBroadcast[sender.tag].id else { return }
            unFollowCategory(id: id)
        
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
    func bindingNotAuth() {
        takeBroadcast = fitMeetStream.getCategory()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.filtredBroadcast = response.data!
                    self.searchView.collectionView.reloadData()
                }
        })
    }
    func bindingLikes() {
        takeBroadcast = fitMeetStream.getCategoryPrivate()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.filtredBroadcast.removeAll()
                    self.filtredBroadcast = response.data!.filter { $0.isFollow ?? false}
                    self.searchView.collectionView.reloadData()
                }
        })
    }
    func bindingLikesNot() {
        takeBroadcast = fitMeetStream.getCategory()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.filtredBroadcast.removeAll()
                    self.filtredBroadcast = response.data!.filter { $0.isFollow ?? false}
                    self.searchView.collectionView.reloadData()
                }
        })
    }
    func followCategory(id: Int) {
        takeCategory = fitMeetStream.followCategory(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
       
            }
        })
    }
    func unFollowCategory(id: Int) {
        unCategory = fitMeetStream.unFollowCategory(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil {
    
            }
        })
    }
}
