//
//  EXDataSourse.swift
//  FitMeet
//
//  Created by novotorica on 01.05.2021.
//

import Foundation
import Foundation
import UIKit


extension StreamingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
      //  return listBroadcast.count
        return listChanell.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return viewModel.shared().count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamingViewCell", for: indexPath) as! StreamingViewCell
     //   let text = listBroadcast[indexPath.row].name
     //   let text = listBroadcast[indexPath.section].name
        let text = listChanell[indexPath.section].name
        let title = listChanell[indexPath.section].title
        let description = listChanell[indexPath.section].description
        guard let textGuard = text,let guardtitle = title,let guarddescription = description else { return  cell}
        
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.8
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        cell.titleLabel.text = "\(textGuard)"
        cell.nameLabel.text = guardtitle
        cell.descriptionLabel.text = guarddescription
        //cell.imageChanell.image = 
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        return headerView
        
    }
}
     
