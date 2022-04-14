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
    let ch = CalculateVC()
    let search = SearchVC()
    
    override func loadView() {
        super.loadView()
        view = monetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        makeNavItem()
        actionButton()
        actionBtnCalculate()
    }
    func actionButton(){
        self.monetView.buttonIncomecalculator.addTarget(self, action: #selector(actionBtnCalculate), for: .touchUpInside)
    }
    @objc func actionBtnTariff() {
        self.monetView.buttonIncomecalculator.backgroundColor = UIColor(hexString: "#BBBCBC")
        removeAllChildViewController(ch)
        configureChildViewController(loadingVC, onView:monetView.selfView )
        
    }
    @objc func actionBtnCalculate() {
        self.monetView.buttonIncomecalculator.backgroundColor = UIColor(hexString: "#3B58A4")
        removeAllChildViewController(loadingVC)
        configureChildViewController(ch, onView:monetView.selfView )
    }
 
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
                    let backButton = UIButton()
                    backButton.anchor( width: 40, height: 30)
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "Back1"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                   
        
                    let titleLabel = UILabel()
                   titleLabel.text = "Monetization"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .center
                   stackView.axis = .horizontal

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
  
    }
 
    //MARK: - Selectors
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
//MARK: - UISearchBarDelegate
//extension MonetezeitionVC: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        
//            let searchBar = searchController.searchBar
//             print("Search == \(searchBar)")
//           
//
//    }
//    func connectUser (broadcastId:String?,channellId: String?) {
//        
//        guard let broadID = broadcastId,let id = channellId else { return }
//        SocketWatcher.sharedInstance.getTokenChat()
//        SocketWatcher.sharedInstance.establishConnection(broadcastId: "\(broadID)", chanelId: "\(id)")
//    }
//}
//extension MonetezeitionVC: SearchData {
//    func searchData() {
//        print("all")
//    }
//
//
//}
