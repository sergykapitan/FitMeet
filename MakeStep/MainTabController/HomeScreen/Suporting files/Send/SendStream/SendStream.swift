//
//  SendStream.swift
//  MakeStep
//
//  Created by Sergey on 04.02.2022.
//

import Foundation
import Combine
import UIKit



class SendStream: UIViewController,UITabBarControllerDelegate {
   
    
    
    

    var list = ["Upload video","Start New Stream"]
    var image = [UIImage(named: "upload"),UIImage(named: "uploadStream")]
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
    var label: UILabel = {
        let label = UILabel()
        label.text = "Create"
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        makeTableView()
        [butH, label,tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        butH.setContentHuggingPriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            butH.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            butH.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
           // butH.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            butH.heightAnchor.constraint(equalToConstant:35),
            butH.widthAnchor.constraint(equalToConstant: 45),
           
            label.topAnchor.constraint(equalTo: butH.bottomAnchor,constant: 3),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
           
        ])

    }
 
    //MARK: - Selectors

    private func makeTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SendStreamCell.self, forCellReuseIdentifier: SendStreamCell.reuseID)
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
    }
}

