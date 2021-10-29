//
//  ExMytariff.swift
//  MakeStep
//
//  Created by Sergey on 28.10.2021.
//

import Foundation
import UIKit

extension MyTariff : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.channel?.subscriptionPlans?.count else { return 3}
        return count
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TarrifCell.reuseID, for: indexPath) as! TarrifCell
        guard let monetPlan = self.channel?.subscriptionPlans else { return cell}
        let arr = monetPlan[indexPath.section]
        cell.nameMonetezationLabel.text = arr.name
        cell.descriptionLabel.text = arr.description
        cell.priceLabel.text = "\(arr.periodCount)" + "\(arr.periodType)" 
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
        headerView.backgroundColor = UIColor(hexString: "#F9FAFC")// UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
           return headerView
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }

    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

}
