//
//  LandscapeVC.swift
//  MakeStep
//
//  Created by Sergey on 26.10.2021.
//

import Foundation
import UIKit

class LandscapeVC: UIViewController {
    
    let landscapeView = LandscapeVCCode()
 
    override func loadView() {
        super.loadView()
        view = landscapeView
     
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      

    }
 
    //MARK: - Selectors

    private func makeTableView() {
       
    }
}

