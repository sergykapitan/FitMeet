//
//  LandscapeVC.swift
//  MakeStep
//
//  Created by Sergey on 26.10.2021.
//

import Foundation
import UIKit

class MyTariff: UIViewController {
    
    let landscapeView = MytariffVCCode()
 
    override func loadView() {
        super.loadView()
        view = landscapeView
     
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let spinner = UIActivityIndicatorView(style: .gray)
               spinner.translatesAutoresizingMaskIntoConstraints = false
               spinner.startAnimating()
               view.addSubview(spinner)

               // Center our spinner both horizontally & vertically
               NSLayoutConstraint.activate([
                   spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
               ])
           }
      

    
 
    //MARK: - Selectors

}

