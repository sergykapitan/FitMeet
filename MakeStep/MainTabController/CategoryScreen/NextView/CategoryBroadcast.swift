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

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
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
       // title = categoryTitle
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeTableView()
        navigationItem.largeTitleDisplayMode = .always
        makeNavItem()
        actionButton()

    }
    
    func actionButton() {
        categoryView.buttonAll.addTarget(self, action: #selector(actionAll), for: .touchUpInside)
        categoryView.buttonPopular.addTarget(self, action: #selector(actionPopular), for: .touchUpInside)
        categoryView.buttonNew.addTarget(self, action: #selector(actionNew), for: .touchUpInside)
        categoryView.buttonViewers.addTarget(self, action: #selector(actionViewers), for: .touchUpInside)

    }
    
    func makeNavItem() {
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = categoryTitle
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
                    let backButton = UIButton()
                    backButton.setImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)

                   let stackView = UIStackView(arrangedSubviews: [backButton ,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                  stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "notifications1"), style: .plain, target: self, action:  #selector(rightHandAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(rightHandAction))
        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem,timeTable]
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
    }
    
    @objc
    func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func actionAll() {
        categoryView.buttonAll.backgroundColor = UIColor(hexString: "#3B58A4")
        categoryView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")

        sortListCategory = listBroadcast
        self.categoryView.tableView.reloadData()
    }
    @objc func actionPopular() {
        
        categoryView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonPopular.backgroundColor = UIColor(hexString: "#3B58A4")
        categoryView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")
        
        
        
        sortListCategory = listBroadcast.filter { ($0.categories?.first?.isPopular ?? false) }
        self.categoryView.tableView.reloadData()
    }
    @objc func actionNew() {
        
        categoryView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonNew.backgroundColor = UIColor(hexString: "#3B58A4")
        categoryView.buttonViewers.backgroundColor = UIColor(hexString: "#BBBCBC")
        
        
        sortListCategory = listBroadcast.filter { ($0.categories?.first?.isNew ?? false) }
        self.categoryView.tableView.reloadData()
    }

    @objc func actionViewers() {
        
        categoryView.buttonAll.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonPopular.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonNew.backgroundColor = UIColor(hexString: "#BBBCBC")
        categoryView.buttonViewers.backgroundColor = UIColor(hexString: "#3B58A4")
      
        sortListCategory = listBroadcast.filter{ $0.followersCount ?? 0 > 1}
        self.categoryView.tableView.reloadData()
    }
    @objc func editButtonTapped() -> Void {
            print("Hello Edit Button")
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

