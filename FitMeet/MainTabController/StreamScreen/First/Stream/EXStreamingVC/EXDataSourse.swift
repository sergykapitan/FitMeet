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
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StreamingViewCell", for: indexPath) as! StreamingViewCell
       // let text = viewModel.shared()[indexPath.row].searchText
        cell.titleLabel.text = "NameBroadcast"
        return cell
    }
}
