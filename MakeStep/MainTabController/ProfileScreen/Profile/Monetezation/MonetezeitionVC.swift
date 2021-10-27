//
//  MonetezeitionVC.swift
//  MakeStep
//
//  Created by Sergey on 27.10.2021.
//

import UIKit

class MonetezeitionVC: UIViewController {
    
    let monetView = MonetezeitionVCode()
    let loadingVC = MyTariff()
    
    
    override func loadView() {
        super.loadView()
        view = monetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        makeNavItem()
        actionButton()

      
    }
    func actionButton(){
        self.monetView.buttonMytariffs.addTarget(self, action: #selector(actionBtnTariff) , for: .touchUpInside)
        self.monetView.buttonIncomecalculator.addTarget(self, action: #selector(actionBtnCalculate), for: .touchUpInside)
    }
    @objc func actionBtnTariff() {
        configureChildViewController(childController: loadingVC, onView:monetView.selfView )
    }
    @objc func actionBtnCalculate() {
        let ch = ProfileVC()
        configureChildViewController(childController: ch, onView:monetView.selfView )
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
 
    //MARK: - Selectors
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
