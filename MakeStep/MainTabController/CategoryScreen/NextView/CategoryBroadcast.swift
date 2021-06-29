//
//  CategoryBroadcast.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import Combine
import UIKit

class CategoryBroadcast: UIViewController,CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        print("segmentedControl index changed to \(index)")
        if index == 0 {
            sortListCategory = listBroadcast            
            self.categoryView.tableView.reloadData()
        }
        if index == 1 {
            sortListCategory = listBroadcast.filter { ($0.categories?.first?.isPopular ?? false) }
            self.categoryView.tableView.reloadData()
        }
        if index == 2 {
            sortListCategory = listBroadcast.filter { ($0.categories?.first?.isNew ?? false) }
            self.categoryView.tableView.reloadData()
        }
        if index == 3 {
           // sortListCategory = listBroadcast.filter { ($0.categories?.first?.followersCount > 1) }
            sortListCategory = listBroadcast.filter { ($0.categories?.first?.isNew ?? false) }
            self.categoryView.tableView.reloadData()
        }
    }
    
  
    let categoryView = CategoryBroadcastCode()
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
    var sortListCategory: [BroadcastResponce] = []
    var categoryid: Int?
    var categoryTitle: String?
   // let viewModel = ViewModel()

    
    
    //MARK - LifeCicle
    override func loadView() {
        view = categoryView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        categoryView.tableView.reloadData()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        binding(categoryId: categoryid ?? 30)
        title = categoryTitle
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeTableView()
        categoryView.segmentControll.setButtonTitles(buttonTitles: ["All","Popular","New","Viewers"])
        categoryView.segmentControll.delegate = self
        navigationItem.largeTitleDisplayMode = .always
        makeNavItem()
       
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

    }
    func makeNavItem() {

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
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
    func binding(categoryId: Int) {
        takeBroadcast = fitMeetStream.getBroadcastCategoryId(categoryId: categoryId)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in           
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.sortListCategory = response.data!
                    self.categoryView.tableView.reloadData()
                }
        })
    }

    private func makeTableView() {
        categoryView.tableView.dataSource = self
        categoryView.tableView.delegate = self
        categoryView.tableView.register(CategoryBroadcastCell.self, forCellReuseIdentifier: CategoryBroadcastCell.reuseID)
    }

}

