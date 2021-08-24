//
//  SendVC.swift
//  MakeStep
//
//  Created by novotorica on 23.08.2021.
//

import Foundation
import Combine
import UIKit



class SendVC: UIViewController,UITabBarControllerDelegate {
    
    

    var list = ["Send a complaint...","Copy link","Share with..."]
    
    
    // MARK: Views
//    let cardView: UIView = {
//        let view = UIView()
//       // view.backgroundColor = .blue
//      // view.translatesAutoresizingMaskIntoConstraints = false
//       // view.clipsToBounds = true
//            return view
//        }()
    
    var butH: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Line"), for: .normal)
        return button
    }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()

    
    
 //   let sendView = SendVCCode()
//
//    @Inject var fitMeetStream: FitMeetStream
//    private var takeBroadcast: AnyCancellable?
//
//    @Inject var fitMeetApi: FitMeetApi
//    private var takeUser: AnyCancellable?
//    private var followBroad: AnyCancellable?
//
//

    
    //MARK - LifeCicle
//    override func loadView() {
//        view = sendView
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.backgroundColor = .white
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
//
//
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        makeTableView()
        // Subviews
        [butH, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        butH.setContentHuggingPriority(.required, for: .vertical)
        
        let inset: CGFloat = 24
        NSLayoutConstraint.activate([
            butH.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            butH.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            butH.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -inset),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
           
        ])

    }


 
    //MARK: - Selectors

    private func makeTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SendVCCell.self, forCellReuseIdentifier: SendVCCell.reuseID)
    }
}

