//
//  CommissionVC.swift
//  MakeStep
//
//  Created by Sergey on 16.02.2022.
//


import Foundation
import UIKit
import Combine

class CommissionVC: UIViewController {

    let commissionView = CommissionVCCde()
 
    override func loadView() {
        super.loadView()
        view = commissionView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        makeNavItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
                    let backButton = UIButton()
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                    backButton.anchor(width:30,height: 30)
        
                    let titleLabel = UILabel()
                   titleLabel.text = "Monetization"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
  
    }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    private func actionButton() {
      
      
    }
    @objc func actionLabelComission() {
       
    }

}

