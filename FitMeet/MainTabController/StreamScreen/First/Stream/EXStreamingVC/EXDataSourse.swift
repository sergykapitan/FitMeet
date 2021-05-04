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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return viewModel.shared().count
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamingViewCell", for: indexPath) as! StreamingViewCell
        let text = listBroadcast[indexPath.row].name
        guard let textGuard = text else { return  cell}
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.8
        cell.backgroundColor = .white
        cell.titleLabel.text = "\(textGuard)"
        return cell
    }
}
