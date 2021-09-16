//
//  SendCoach.swift
//  MakeStep
//
//  Created by novotorica on 15.09.2021.
//


import Combine
import UIKit



class SendCoach: UIViewController,UITabBarControllerDelegate {
    
    

    var list = ["Share with...","Copy link","Available for...","Edit","Delete stream"]
    var url: String?
    
    // MARK: Views
    var butH: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8"), for: .normal)
        return button
    }()
    var tableView: UITableView = {
        let table = UITableView()
        return table
    }()

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
  //.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            butH.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            butH.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            butH.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            butH.heightAnchor.constraint(equalToConstant:15),
            butH.widthAnchor.constraint(equalToConstant: 32),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            
           
        ])

    }
 
    //MARK: - Selectors

    private func makeTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SendCoachCell.self, forCellReuseIdentifier: SendCoachCell.reuseID)
    }
}

